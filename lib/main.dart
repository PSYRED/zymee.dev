import 'package:flutter/material.dart';
import 'package:zymee/resources/auth_methods.dart';
import 'package:zymee/widgets/checkVerification.dart';
import './screens/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/HomeScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zymee.',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: AuthMethods().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return  CheckVerification();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
