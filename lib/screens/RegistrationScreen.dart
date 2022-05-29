import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../modals/userModals.dart';
import '../resources/auth_methods.dart';
import 'HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  //The following variables are required

  //FormKey
  final _formKey = GlobalKey<FormState>();

  //Editing controllers
  final fullNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  //Creating auth instance
  final AuthMethods _auth = AuthMethods();


  @override
  Widget build(BuildContext context) {

    //Full Name Field
    final fullNameField = TextFormField(
      autofocus: false,
      controller: fullNameEditingController,
      keyboardType: TextInputType.name,
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
        fullNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.portrait_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full name",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //email field
    final emailTextField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
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
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //Telephone field
    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: phoneNumberEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Field cannot be empty");
        }
        const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
        final regExp = RegExp(pattern);
        if (!regExp.hasMatch(value)) {
          return ("Number does not meet requirements");
        }
        return null;
      },
      onSaved: (value) {
        phoneNumberEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.call),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //Password
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordEditingController,
      //Keyboard type not required for pasword.
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
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //Confirm Password
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );


    //loginButton
    final signUpButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.indigoAccent,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
                if(passwordEditingController.text == confirmPasswordEditingController.text && emailEditingController.text.isNotEmpty){
                  bool res = await _auth.registerWithEmailAndPassword(
                      context, emailEditingController.text, passwordEditingController.text, fullNameEditingController.text, phoneNumberEditingController.text);
                  if (res) {
                    postToUserCollection();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen())
                    );
                  }
                } else {
                  Fluttertoast.showToast(msg: "Error, Please fill in values correctly");
                }
          },
          child: Text("SignUp",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ));




    return  MaterialApp(
      themeMode: ThemeMode.system,
      home: Scaffold(
          appBar: AppBar(
            actions: [],
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_sharp, color: Colors.indigoAccent),
              onPressed: () {
                //Passing this to our root.
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(
              child: SingleChildScrollView(
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
                                SizedBox(height: 35),

                                //WELCOME TO ZYMEE.
                               const SizedBox(
                                  height: 20,
                                  child: Text(
                                    "Just a few steps",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                               const SizedBox(height: 25),
                                fullNameField,
                               const SizedBox(height: 25),
                                emailTextField,
                               const SizedBox(height: 25),
                                phoneNumberField,
                               const SizedBox(height: 25),
                                passwordField,
                               const SizedBox(height: 25),
                                confirmPasswordField,
                               const SizedBox(height: 25),
                                signUpButton,
                               const SizedBox(height: 25),
                              ],
                            )))),
              ))),
    );
  }
  postToUserCollection() async {
    //calling our firestore
    //calling our user model
    //sending values
    UserModel userModel = UserModel();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    //writing values
    userModel.email = _auth.user.email;
    userModel.uid = _auth.user.uid;
    userModel.fullName = fullNameEditingController.text;
    userModel.phoneNumber = phoneNumberEditingController.text;

    await firebaseFirestore
        .collection('users')
        .doc(_auth.user.uid)
        .set(userModel.toMap());


  }
}
