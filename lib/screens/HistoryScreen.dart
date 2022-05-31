import 'package:flutter/material.dart';
import '../resources/firestore.dart';
import 'package:intl/intl.dart';

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
          title: const Text("My Meetings"),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
                      stream: FirestoreMethods().meetingHistory,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) => ListTile(
                                title: Text('Room ID: ${(snapshot.data! as dynamic).docs[index]['meetingName']}'),
                              subtitle: Text(
                                'Joined on ${DateFormat.yMMMd().format((snapshot.data! as dynamic).docs[index]['CreatedAt'].toDate())}',
                              ),
                            )
                        );
                      })
              )
          );
  }
}
