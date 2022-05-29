import 'package:flutter/material.dart';

class MeetingRoom extends StatefulWidget {
  const MeetingRoom({Key? key}) : super(key: key);

  @override
  State<MeetingRoom> createState() => _MeetingRoomState();
}

class _MeetingRoomState extends State<MeetingRoom> {
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
