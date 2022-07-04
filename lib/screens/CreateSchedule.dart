import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../resources/firestore.dart';
import '../resources/auth_methods.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:googleapis/calendar/v3.dart' as v3;
import 'package:googleapis_auth/auth_io.dart';
import '../utils/colors.dart';

class CreateSchedule extends StatefulWidget {
  DateTime date;
   CreateSchedule({Key? key, required this.date}) : super(key: key);

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {

  final ItemColors _color = ItemColors();

  final TextEditingController roomName = TextEditingController();
  final TextEditingController roomDescription = new TextEditingController();

  FirestoreMethods _firebaseMethods = FirestoreMethods();


  //Creating variables for google APIs
  var _credentials;
  final AuthMethods _auth = AuthMethods();
  static const _scopes = const [v3.CalendarApi.calendarScope];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomName.text = generateRandomString(6);
    setState(() {});
  }


  Future<bool> exportToGoogleCalendar({
    required String identifier,
    required String summary,
    required String description,
    required DateTime startDateTime,
    required String startTimeZone,
    required DateTime endDateTime,
    required String endTimeZone,
  }) async {
    setCredentials(identifier: identifier);
    //create event for adding to calendar
    v3.Event event = v3.Event();

    v3.EventDateTime start = v3.EventDateTime(); //Setting start time
    v3.EventDateTime end = v3.EventDateTime(); //setting end time

    start.dateTime = startDateTime;
    start.timeZone = startTimeZone;

    end.dateTime = endDateTime;
    end.timeZone = endTimeZone;

    return await _insertEvent(event);
  }


  //add events
  Future<bool> _insertEvent(v3.Event event) async {
    try {
      await clientViaUserConsent(_credentials, _scopes, _launchURL)
          .then((AuthClient client) {
        var calendar = v3.CalendarApi(client);
        String calendarId = "primary";

        calendar.events.insert(event, calendarId).then((value) {
          if (value.status == "confirmed") {
            //  print('Event added in google calendar');
            return true;
          } else {
            //  print("Unable to add event in google calendar");
            return false;
          }
        });
      });
    } catch (e) {
      return false;
    }
    return false;
  }

  void setCredentials({required String identifier}) {
    if (Platform.isAndroid) {
      _credentials = ClientId(identifier, "");
    } else if (Platform.isIOS) {
      _credentials = ClientId(identifier, "");
    }
  }


  void _launchURL(String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Colors.black,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Colors.orange[500],
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

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
          prefixIcon: Icon(Icons.tag),
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
          prefixIcon: Icon(Icons.info),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter meeting Description",
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );


    final CreateButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: _color.btnColor,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
            if(roomName.text.isNotEmpty){
              _firebaseMethods.scheduleMeeting(roomName.text, roomDescription.text, widget.date);
              exportToGoogleCalendar(identifier: "612417216134-6pbhidv2usn1enovqlj9u7el5oqjq3co.apps.googleusercontent.com", summary: "Meeting scheduled on zymee created by {$_auth.user.email}", description: roomDescription.text, startDateTime: widget.date, startTimeZone: "3PM GMT", endDateTime: widget.date, endTimeZone: "4PM GMT");
              Fluttertoast.showToast(msg: "Meeting Scheduled");

              }
             else {
              Fluttertoast.showToast(msg: "Error, Please fill in values correctly");
            }
          },
          child: Text("Save updates",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: _color.txtColorYT,
                  fontWeight: FontWeight.bold)),
        ));


    return Scaffold(
      backgroundColor: _color.background,
      appBar: AppBar(
        title: Text("Creating Schedule"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
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
              color: _color.txtColorBL,
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

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }


}
