import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../modals/userModals.dart';
import '../resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  //The following Variables are required
  UserAccount _userAccount = UserAccount();
  final AuthMethods _auth = AuthMethods();

  //Defines whether user is editting or view profile
  bool isEdit = false;

  final _formKey = GlobalKey<FormState>();

  //Initiating state and getting user data
  @override
  void initState() {
    super.initState();
    //initializing cloud firestore
    FirebaseFirestore.instance
        .collection('UserAccount')
        .doc(_auth.user.uid)
        .get()
        .then((value) {
      this._userAccount = UserAccount.fromMap(value.data());
      setState(() {});
    });
  }

  //Text Controller to edit user Info
  final userNameConroller = new TextEditingController();
  final bioController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.indigoAccent),
          onPressed: () {
            //Passing this to our root.
            Navigator.of(context).pop();
          },
        ),
        title: Text("My Profile"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
        body: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isEdit ?
                    FormProfile() :
                    ProfileAppBar(_userAccount.profilePictureUrl, changeProfile),
                    const SizedBox(height: 10.0),
                    Center(child: ProfileButton()),
                  ],
                ),
              )
        )
    ));
  }

  Widget ProfileAppBar(String? profileURL, void Function() onPressed){
    return Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: 400.0,
        child: Center(
          child: Column(
            children: <Widget>[
              GestureDetector(
                child:
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: profileURL == null ?
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/zymee-dev.appspot.com/o/assets%2F%20Default.png?alt=media&token=7bc1d685-7dcb-49c3-9ff4-21622bf2a7f6"),
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )) :
                      ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: Ink.image(
                              image: NetworkImage(
                                  "${_userAccount.profilePictureUrl}"),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ))
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20.0),
              Container(
                child: _userAccount.username == "" ? Text("Username unavailable") :  Text("${_userAccount.username}",
                  style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                color: Colors.orange,
                child:_userAccount.bio == "" ? Text("Bio unavailable") : Text("${_userAccount.bio}",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ),
              const SizedBox(height: 16.0)
            ],
        ),
      ),
    );
  }

  Widget ProfileButton(){
    return  GestureDetector(
        onTap: () async{
          isEdit = !isEdit;
            setState(() {
              updateProfile(userNameConroller.text, bioController.text);
          });
        },
        child: Container(
            height: 35.0,
            width: 50.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.indigo.shade400,
            ),
            child: isEdit == false ?
            const Text("Edit",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ) :
            const Text("Save",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)
            )));
  }

  Widget FormProfile(){


    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameConroller,
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
        userNameConroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "username",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final bioField = TextFormField(
      autofocus: false,
      controller: bioController,
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
        bioController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Add Bio",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );


    return Center(
      child: Container(
              height: 300.0,
              width: 250.0,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    userNameField,
                    const SizedBox(height: 10.0),
                    bioField
                  ],
                ),
              ),
      ),
    );
  }

  void changeProfile() {

  }

  void updateProfile(String username, String bio) async{
    //calling our firestore
    //calling our user model
    //sending values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    //Updating profile with a downdable link of our image.
    if(isEdit == false && userNameConroller.text.isNotEmpty) {
      await firebaseFirestore
          .collection('UserAccount')
          .doc(_auth.user.uid)
          .update({
        'username': username,
        'bio': bio
      });
      log("Sending Data to FireStore");
      Fluttertoast.showToast(msg: "Updating to profile ...");
    }

  }
}
