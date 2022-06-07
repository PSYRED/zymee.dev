import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  List<Contact>? contacts;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoneContacts();
  }

  void getPhoneContacts() async{
    if (await FlutterContacts.requestPermission()){
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: (contacts == null) ?
      Center(child: CircularProgressIndicator())
          :
          ListView.builder(
              itemCount: contacts!.length,
              itemBuilder: (BuildContext context, int index)
          {
            Uint8List? image = contacts![index].photo;
            String number = (contacts![index].phones.isNotEmpty) ? contacts![index].phones.first.number : "---";
            return ListTile(
              leading: (image == null) ? CircleAvatar(child: Icon(Icons.account_circle)) : CircleAvatar(backgroundImage: MemoryImage(image) ),
              title: Text(contacts![index].displayName),
              subtitle: Text(number),
              onTap: (){
                launch('tel: ${number}');
              },
            );
          }
          )
    );
  }
}
