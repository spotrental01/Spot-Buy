import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotbuy/Utils/constants.dart';
import 'package:spotbuy/screens/profile.dart/profile_page.dart';

import 'Login/login_screen.dart';
import 'components/bottomnavigationscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {Navigator.push(context, MaterialPageRoute(builder: (context)=>
        StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (cUser().displayName == null) {
            return const Profilepage();
          }
          return TabsPage();
        }
        return const loginScreen();
      },
    ))); });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(child: Image.asset('assets/images/logo_light.png')),
      ),
    );
  }
}
