import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zymee/modals/userModals.dart';
import 'package:zymee/screens/HistoryScreen.dart';
import 'package:zymee/screens/Meeting.dart';
import '../resources/auth_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthMethods _auth = AuthMethods();
  UserModel _userModel = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.user.uid)
      .get()
      .then((value){
        this._userModel = UserModel.fromMap(value.data());
        setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome ${_userModel.fullName}"),
               const SizedBox(height: 20.0),
                Navigation(
                  Icon(Icons.meeting_room),
                  Text("Create Meeting"),
                    (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MeetingRoom()));
                    }
                ),
                const SizedBox(height: 20.0),
                Navigation(
                    Icon(Icons.account_circle),
                    Text("My Profile"),
                        (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MeetingRoom()));
                    }
                ),
                const SizedBox(height: 20.0),
                Navigation(
                    Icon(Icons.access_time),
                    Text("Meeting History"),
                        (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => HistoryMeeting()));
                    }
                ),
                MaterialButton(
                    color: Colors.red,
                    child: Text("Sign out"),
                    onPressed: () {
                      _auth.signOut(context);
                    }
                )
              ],
            ),
      )
    ));
  }

  Widget Navigation(Icon icon, Text label, void Function()? onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            label
          ],
        )
      ),
    );
  }

}

/*
* TODO:
* - Design Navigation
*
*
*
* */