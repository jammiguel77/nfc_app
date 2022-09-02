import 'package:demo_app/screens/homepage.dart';
import 'package:demo_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
        title: 'NFC',
        theme: ThemeData(
          primaryColor: Colors.black,
          fontFamily: "PulpDisplay",
        ),
        home: const HomePage());
  }
}
