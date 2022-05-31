import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethods _auth = AuthMethods();

  Stream get meetingHistory => _firestore
      .collection('UserAccount')
      .doc(_auth.user.uid)
      .collection('meetings')
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
}