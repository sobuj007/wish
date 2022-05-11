import 'package:Wish/Sharedpref/SharedPrefManager.dart';
import 'package:Wish/views/mainlayouts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/main.dart';
import 'package:Wish/views/auth/phones.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  starttimer() async {
    if (await SharedPrefManager.isUserLogin() == true) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => MainLayouts()), (route) => false);
    }

    // Future.delayed(Duration(seconds: 2)).then((value) => {
    //       Navigator.push(context, CupertinoPageRoute(builder: (_) => Phones()))
    //     });
  }

  @override
  void initState() {
    // TODO: implement initState
    starttimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: sheet.pads(5.w, 2.h),
        child: Center(
            child: Column(
          children: [
            Container(
              height: 20.h,
              color: Colors.greenAccent,
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              "Welcome to Wish shopping app",
              style: sheet.custom(Colors.black, 28.0, FontWeight.bold),
            ),
            SizedBox(
              height: .5.h,
            ),
            Text(
              "Thank you for installing Wish shopping app, click Continue to proceed to Registation number ",
              style: sheet.regularMedium(Colors.black54),
            ),
            SizedBox(
              height: 3.h,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (_) => Phones()));
              },
              child: Container(
                width: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: col.primary,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Continue',
                    style: sheet.mediumMedium(Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 3.h,
              ),
            ),
          ],
        )),
      )),
    );
  }
}
