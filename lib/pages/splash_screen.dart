import 'dart:async';

import 'package:catalog/pages/categories_screen.dart';
import 'package:catalog/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    final _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      // String username = _auth.currentUser?.email
      //     ?.split('@')
      //     .first
      //     .replaceAll(RegExp(r'[^a-zA-Z]'), '') ?? '';
      // print("user into--- $username");
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Categoris(userName: _auth.currentUser?.email)));
        },
      );
    } else {
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: const Center(
          child: Text(
            "Welcome to catalog",
            style: TextStyle(
                fontSize: 29, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
