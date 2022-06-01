import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymee/widgets/checkVerification.dart';
import '../resources/auth_methods.dart';

import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // The following variables are required;
  //form key
  //emailController , passwordController
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //Create an instance of authMethods
  //Firebase auth from instance created in our app
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email!");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );


    //passwordField
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regexp = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regexp.hasMatch(value)) {
            return ("Please Enter Valid PAssword(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key_sharp),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //loginButton
    //Login Function at the bottom
    final loginButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.indigoAccent,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
            //ADD LOGIN FUNCTION
            //ADD LOGIN FUNCTION
            bool res = await _authMethods.signInWithEmail(context, emailController.text, passwordController.text);
            print("Login Button Pressed");
            if(res){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CheckVerification())
              );
            }
          },
          child: Text("Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ));

    final googleSignInButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.pinkAccent.shade200,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
            //ADD LOGIN FUNCTION
            bool res = await _authMethods.signInWithGoogle(context);
            print("Google Signin Button Pressed");
            if(res){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CheckVerification())
              );
            }
          },
          child: Text("Continue with Google",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ));


    return SafeArea(
      child: Scaffold(
          body: Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                    child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //PADDING
                                SizedBox(height: 45),
                                //WELCOME TO ZYMEE.
                                const SizedBox(
                                  height: 40,
                                  child: Text(
                                    "Login to Zymee.",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                               const SizedBox(height: 45),
                                emailField,
                               const  SizedBox(height: 25),
                                passwordField,
                               const SizedBox(height: 35),
                                loginButton,
                               const SizedBox(height: 15),
                                googleSignInButton,
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                   const Text("Don't have an account? "),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationScreen()));
                                      },
                                      child: const Text("SignUp",
                                          style: TextStyle(
                                              color: Colors.indigoAccent,
                                              fontWeight: FontWeight.w700,
                                              fontSize: (15))),
                                    )
                                  ],
                                )
                              ],
                            )))),
              )))
    );
  }
}
