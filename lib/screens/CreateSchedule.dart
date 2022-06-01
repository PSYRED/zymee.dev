import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../resources/firestore.dart';
import 'package:intl/intl.dart';

class CreateSchedule extends StatefulWidget {
  DateTime date;
   CreateSchedule({Key? key, required this.date}) : super(key: key);

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {

  final TextEditingController roomName = new TextEditingController();
  final TextEditingController roomDescription = new TextEditingController();

  FirestoreMethods _firebaseMethods = FirestoreMethods();


  @override
  Widget build(BuildContext context) {

    final roomIdField = TextFormField(
      autofocus: false,
      controller: roomName,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email!");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a room name");
        }
        return null;
      },
      onSaved: (value) {
        roomName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Please add room Name",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final roomDescriptionField = TextFormField(
      autofocus: false,
      controller: roomDescription,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter meeting Description!");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter meeting description");
        }
        return null;
      },
      onSaved: (value) {
        roomDescription.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter meeting Description",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );


    final CreateButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.indigoAccent,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
            if(roomName.text.isNotEmpty){
              _firebaseMethods.scheduleMeeting(roomName.text, roomDescription.text, widget.date);
              Fluttertoast.showToast(msg: "Meeting Scheduled");
              Navigator.of(context).pop();
              }
             else {
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


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Creating Schedule"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.indigoAccent),
          onPressed: (){ Navigator.of(context).pop();},
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              Text("${ DateFormat.yMMMMd().format(widget.date)}", style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 30.0
      )),
              const SizedBox(height: 20.0),
              roomIdField,
              const SizedBox(height: 20.0),
              roomDescriptionField,
              const SizedBox(height: 20.0),
              CreateButton
            ],
          ),
        ),
      ),
    );
  }
}
