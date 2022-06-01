import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymee/screens/SetUpScreen.dart';

import '../modals/userModals.dart';

class VerificationScreen extends StatefulWidget {
  bool? isEmail;
  VerificationScreen({Key? key, required this.isEmail}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  bool isVerified = false;
  bool canResend = false;
  Timer? timer;

  @override
  void initState() {
    //Declaring variables
    User? isUserVerified = FirebaseAuth.instance.currentUser;
    isVerified = isUserVerified!.emailVerified;
    if (!isVerified) {
      sendVericationEmail();

      Timer.periodic(
        Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }



  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }



  Future checkEmailVerified() async {
    //calll after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerified) {
      postToUserCollection(isVerified);
      timer?.cancel();
    }
  }



  Future sendVericationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResend = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResend = true);
      Fluttertoast.showToast(msg: 'Another Verification sent');
    } catch (e) {
      String message = e.toString();
      Fluttertoast.showToast(msg: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Screen",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: widget.isEmail == true ?
          Container(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Text("An email has been sent to you", style: TextStyle(color: Colors.black, fontSize: 22.0)),
                const SizedBox(height: 20.0),
                Text("Didn't receive", style: TextStyle(color: Colors.black, fontSize: 22.0)),
                const SizedBox(height: 20.0),
                MaterialButton(
                    onPressed: (){
                      sendVericationEmail();
                      Fluttertoast.showToast(msg: "Verification Sent");
                    },
                    child: const Text("Resend Verification"),
                    color: Colors.lightGreen,

                )
              ],
            ),
          )

              : Text(
              "Verification message sent -> ${widget.isEmail}")
      ),
    );
  }



  postToUserCollection(bool isVerified) async {
    //calling our firestore
    //calling our user model
    //sending values

    User? user = FirebaseAuth.instance.currentUser;
    var updatingVerification =
    FirebaseFirestore.instance.collection('users').doc(user!.uid);

    UserModel userModel = UserModel();

    //writing values
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.isVerified = isVerified;

    await updatingVerification.update({'isVerified': userModel.isVerified});
    Fluttertoast.showToast(msg: "User Verification successfull");

    Navigator.pushReplacement(
        (context),
        MaterialPageRoute(builder: (context) => SetUpScreen()),
            );
  }
}


