import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthMethods _auth = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Home"),
                MaterialButton(
                    color: Colors.red,
                    child: Text("Sign out"),
                    onPressed: () {
                      _auth.signOut(context);
                    }
                )
              ],
            ),
      )
    ));
  }
}
