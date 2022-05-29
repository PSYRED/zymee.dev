import 'package:flutter/material.dart';

class HistoryMeeting extends StatefulWidget {
  const HistoryMeeting({Key? key}) : super(key: key);

  @override
  State<HistoryMeeting> createState() => _HistoryMeetingState();
}

class _HistoryMeetingState extends State<HistoryMeeting> {
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
                  Text("Meeting Screen")
                ],
              )
          ),
        )
    ));
  }
}
