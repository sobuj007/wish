import 'package:Wish/notifiy/Messaging.dart';
import 'package:Wish/views/splash.dart';
import 'package:flutter/material.dart';

import '../Sharedpref/SharedPrefManager.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starttimer();
  }

  starttimer() async {
    Messaging().sendtoAll("Wish", "welcome to wish");

    Future.delayed(Duration(seconds: 4)).then((value) => {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => Splash()), (route) => false)
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        alignment: Alignment.center,
        child: Image(image: AssetImage('assets/sp.gif')),
      )),
    );
  }
}
