import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zymee/modals/userModals.dart';
import 'package:zymee/screens/ContactScreen.dart';
import 'package:zymee/screens/HistoryScreen.dart';
import 'package:zymee/screens/Meeting.dart';
import 'package:zymee/screens/MeetingSchedule.dart';
import 'package:zymee/screens/ProfileScreen.dart';
import '../resources/auth_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthMethods _auth = AuthMethods();
  UserModel _userModel = UserModel();
  UserAccount _userAccount = UserAccount();

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // TO REPLACE
                  userProfile(),


                 const SizedBox(height: 20.0),
                  customNavigation(
                   const Icon(Icons.meeting_room, size: 50.0),
                   Colors.indigo,
                   const Text("Create Meeting"),
                      (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => Meeting()));
                      }
                  ),
                  const SizedBox(height: 20.0),
                  customNavigation(
                      const Icon(Icons.calendar_today_outlined, size: 50.0),
                     Colors.pinkAccent,
                     const Text("Schedule"),
                          (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => MeetingSchedule()));
                      }
                  ),
                  const SizedBox(height: 20.0),
                  customNavigation(
                      const Icon(Icons.contact_phone_rounded, size: 50.0),
                      Colors.deepOrangeAccent,
                      const Text("Schedule"),
                          (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => ContactScreen()));
                      }
                  ),
                  const SizedBox(height: 20.0),
                  customNavigation(
                     const Icon(Icons.access_time, size: 50.0),
                     Colors.orange,
                     const Text("Meeting History"),
                          (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => HistoryMeeting()));
                      }
                  ),
                  MaterialButton(
                      color: Colors.red,
                      child: const Text("Sign out",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                      ),
                      ),
                      onPressed: () {
                        _auth.signOut(context);
                      }
                  )
                ],
              ),
            ),
      )
    ));
  }


  Widget userProfile() {
    return GestureDetector(
      child: Container(
        width: 150.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(padding: const EdgeInsets.all(8.0),
        child: Row(
            children: <Widget>[

              //Displaying profile picture
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child:  Material(
                    color: Colors.transparent,
                    child: Ink.image(
                        image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/zymee-dev.appspot.com/o/assets%2F%20Default.png?alt=media&token=7bc1d685-7dcb-49c3-9ff4-21622bf2a7f6"),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        child: InkWell(onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProfileScreen()));
                        }),
                ),
              ),)),



              const SizedBox(width: 5.0),
              Text("${_userModel.fullName}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28.0
              ),
              )
          ],
        ),
        ),
      ),
    );
  }


  Widget customNavigation(Icon icon, Color _color ,Text label, void Function()? onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200.0,
        height: 90.0,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 5.0),
                label
              ],
            )
          ),
        ),
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