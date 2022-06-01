import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymee/modals/userModals.dart';
import 'package:zymee/screens/HomeScreen.dart';
import 'package:zymee/screens/verificationScreen.dart';
import '../resources/auth_methods.dart';


class SetUpScreen extends StatefulWidget {
  SetUpScreen({Key? key}) : super(key: key);
  @override
  State<SetUpScreen> createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> {

  final AuthMethods _auth = AuthMethods();
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _bio = new TextEditingController();
  String? profilePictureUrl;

  final _formKey = GlobalKey<FormState>();

  UserModel _userModel = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.user.uid)
        .get()
        .then((value) {
      this._userModel = UserModel.fromMap(value.data());

      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {


    //Email verification Button
    final isEmailVerification = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.lightGreen,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {

            //Add Verification Function
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VerificationScreen(isEmail: true))
            );
          },
          child: Text("Email Verification",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ));

    //Phone verification Button
    final isPhoneVerification = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.lightBlue,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            //Add Verification Function
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VerificationScreen(isEmail: false))
            );
          },
          child: Text("Phone Verification",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ));

    //Username TextField
    final usernameField= TextFormField(
      autofocus: false,
      controller: _username,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your username!");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid username");
        }
        return null;
      },
      onSaved: (value) {
        _username.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.tag),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Add UserName",
          focusColor: Colors.purple,
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final bioField= TextFormField(
      autofocus: false,
      controller: _bio,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your bio!");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter bio");
        }
        return null;
      },
      onSaved: (value) {
        _bio.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_device_info),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter bio",
          focusColor: Colors.deepPurple,
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final SubmitButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.deepPurple,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            SetUpUser();
          },
          child: Text("Set up",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ));

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: _userModel.isVerified == false ?
          Column(
            children: [
                const Text("Choose Verification Method", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
              const SizedBox(height: 20.0),
              isEmailVerification,
              const SizedBox(height: 20.0),
              isPhoneVerification
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ) :
          Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
                  color: Colors.black12
            ),
            child:
            Column(
              children: [
                const Text("Account Set Up", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
                const SizedBox(height: 20.0),
                usernameField,
                const SizedBox(height: 20.0),
                bioField,
                const SizedBox(height: 20.0),
                SubmitButton
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        ),
      ),
    );
  }


  SetUpUser() async {
    //calling our firestore
    //calling our user model
    //sending values
    UserAccount userAccount = UserAccount();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    //writing values

    userAccount.uid = _auth.user.uid;
    userAccount.username = _username.text;
    userAccount.bio = _bio.text;
    userAccount.profilePictureUrl = "https://firebasestorage.googleapis.com/v0/b/zymee-dev.appspot.com/o/assets%2F%20Default.png?alt=media&token=7bc1d685-7dcb-49c3-9ff4-21622bf2a7f6";

    await firebaseFirestore
        .collection('UserAccount')
        .doc(_auth.user.uid)
        .set(userAccount.toMap());
    Fluttertoast.showToast(msg: "Setting up Account \n May take a minute");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen())
    );
  }

}
