import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zymee/screens/LoginScreen.dart';
import 'package:zymee/screens/SetUpScreen.dart';
import '../modals/userModals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/HomeScreen.dart';

class CheckVerification extends StatefulWidget {
   CheckVerification({Key? key}) : super(key: key);

  @override
  State<CheckVerification> createState() => _CheckVerificationState();
}

class _CheckVerificationState extends State<CheckVerification> {

  UserModel _userModel = UserModel();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      this._userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userModel.isVerified == false) {
      print("Verification LOG ----->>> ${_userModel.isVerified}");
      return  SetUpScreen();
    }
    else if(_userModel.isVerified == true)
    {
      print("Verification LOG ----->>> ${_userModel.isVerified}");
      return const HomeScreen();
    }
    return LoginScreen();
  }
}
