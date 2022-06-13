import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymee/screens/HomeScreen.dart';
import 'package:zymee/screens/SetUpScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../modals/userModals.dart';

class VerificationScreen extends StatefulWidget {
  bool? isEmail;
  VerificationScreen({Key? key, required this.isEmail}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  late String _verificationCode;
  bool isVerified = false;
  bool canResend = false;
  Timer? timer;

  final TextEditingController phoneNumber = TextEditingController();




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



    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: phoneNumber,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regexp = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Full Name cannot be empty");
        }
        if (!regexp.hasMatch(value)) {
          return ("Enter Valid name(min. 3 Characters)");
        }
        return null;
      },
      onSaved: (value) {
        phoneNumber.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIconColor: Colors.white,
          filled: true,
          fillColor: Colors.orangeAccent,
          prefixIcon: Icon(Icons.phone_android),
          prefixText: "+48",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone number",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );



    final phoneVerificationButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.orangeAccent,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            _verifyPhone();
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => isPhoneVerification(context, phoneNumber.text))
              );
          },
          child: Text("Verify",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ));




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
              //Rendering for email verification
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
                //Rendering phone verifications
              :
          Padding(padding: EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
                color: Colors.blueGrey.shade400
          ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 35.0),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: const Text("Please enter verification number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white),),
                    ),
                    const SizedBox(height: 35.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: phoneNumberField,
                    ),
                    const SizedBox(height: 46.0),
                    phoneVerificationButton
                  ],
                ),
              ),
          ),
          )

      ),
    );
  }

  


  //Phone Verification Widget
    //The phone verification widget Adds the pin code verification on to the screen.
    //As built in functions work well with our goal, once the pincode completed our user will be authenticated... if the right code is added.
  Widget isPhoneVerification(BuildContext context,String phone){

    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  
    final TextEditingController _pinPutController = TextEditingController();
    final FocusNode _pinPutFocusNode = FocusNode();





    return Scaffold(
      appBar: AppBar(title: Text("CODE SENT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),),),
      body: Container(
        child: Column(

          children: [
            const SizedBox(height: 25.0),
            const Text("A code has been sent to your number."),
            const SizedBox(height: 25.0),
            Container(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                onCompleted: (v) async{
                  try{
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: v))
                        .then((value) async{
                       if(value.user != null){
                         print("User Phone authenticated");
                         isVerified = true;
                         postToUserCollection(isVerified);
                         Fluttertoast.showToast(msg: "Phone authentication Successfull \nCreating User model");
                          Navigator.pushReplacement(context, 
                          MaterialPageRoute(builder: (context) => HomeScreen()));
                       }
                    });
                  }catch(e){
                    FocusScope.of(context).unfocus();
                    _scaffoldkey.currentState!;
                      Fluttertoast.showToast(msg: "Invalid OTP");
                  }
                },
                onChanged: (v){
                  print(v);
                  setState(() {});
                },
              ),
            ))
          ],
        ),
      ),
    );
  }




  //Phone verification method
    //This method is called out to invoke the sending of the message to the number provided.
      _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+48${phoneNumber.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {

          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));

  }

  //Post to user collection as of now is only ran once the verification is complete for email
  // Must implement verifications for phone number as well
  //IT is the element that updates the verification method on our cloud firebase database.
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


