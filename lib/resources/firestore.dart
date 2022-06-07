import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethods _auth = AuthMethods();
  DateTime? selectedDate;

  Stream get meetingHistory => _firestore
      .collection('UserAccount')
      .doc(_auth.user.uid)
      .collection('meetings')
      .snapshots();

  Stream get scheduledMeeting => _firestore
      .collection('UserAccount')
      .doc(_auth.user.uid)
      .collection('ScheduledMeetings')
      .snapshots();

  void addToMeetingHistory(String MeetingName) async {
    try {
      await _firestore
          .collection('UserAccount')
          .doc(_auth.user.uid)
          .collection('meetings')
          .add({
        'meetingName': MeetingName,
        'CreatedAt': DateTime.now(),
      });
    } catch (e) {
      print("Caught Error / ${e}");
    }
  }


  void scheduleMeeting(String meetingName, String meetingDescription, DateTime? _date) async{

    try {
      await _firestore
          .collection('UserAccount')
          .doc(_auth.user.uid)
          .collection('ScheduledMeetings')
          .doc("$_date")
          .set({
        'meetingName': meetingName,
        'MeetingDescription' : meetingDescription,
        'CreatedBy': '${_auth.user.email}',
      });
    } catch (e) {
      print("Caught Error / ${e}");
    }
  }

}