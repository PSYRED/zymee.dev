import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      ),
      backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Create a New Meeting")
                ],
              )
          ),
        )
    ));
  }
}
