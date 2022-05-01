import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../main.dart';

class Style {
  double iconsize = 20.sp;

  double fsthin = 13.sp;
  double fslight = 14.sp;
  double fsregular = 16.sp;
  double fsmedium = 18.sp;
  double fssemi = 20.sp;
  double fsbold = 22.sp;
  String ff = 'SourceSansPro';
  // Map<dynamic, dynamic>? cart;
  dynamic contacts = [];
  // String? fcmtoken;
  // String? duebil;
  // String? ammount;
  // late List<dynamic>? hm = [];
  late List<dynamic>? bm = [];
  var token;
  Map<dynamic, dynamic>? membercard;

  // thins Fonts..........................................

  TextStyle thinLights(c) => TextStyle(
      fontSize: fsthin,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.none,
      letterSpacing: .0);

  TextStyle thinRegular(c) => TextStyle(
      fontSize: fsthin,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  TextStyle thinMedium(c) => TextStyle(
      fontSize: fsthin,
      fontFamily: ff,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  TextStyle thinSmi(c) => TextStyle(
      fontSize: fsthin,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  TextStyle thinBold(c) => TextStyle(
      fontSize: fsthin,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  // Lights Fonts..........................................

  TextStyle lightsLights(c) => TextStyle(
      fontSize: fslight,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.none,
      letterSpacing: .0);

  TextStyle lightsRegular(c) => TextStyle(
      fontSize: fslight,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  TextStyle lightsMedium(c) => TextStyle(
      fontSize: fslight,
      fontFamily: ff,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  TextStyle lightsSmi(c) => TextStyle(
      fontSize: fslight,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  TextStyle lightsBold(c) => TextStyle(
      fontSize: fslight,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
      letterSpacing: .0);

  // Regular Fonts..........................................

  TextStyle regularLights(c) => TextStyle(
      fontSize: fsregular,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.none,
      letterSpacing: .0);

  TextStyle regularRegular(c) => TextStyle(
      fontSize: fsregular,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle regularMedium(c) => TextStyle(
      fontSize: fsregular,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle regularSmi(c) => TextStyle(
      fontSize: fsregular,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle regularBold(c) => TextStyle(
      fontSize: fsregular,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
      letterSpacing: 0);

  // Medium Fonts..........................................

  TextStyle mediumLights(c) => TextStyle(
      fontSize: fsmedium,
      fontFamily: ff,
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.none,
      letterSpacing: 0);

  TextStyle mediumRegular(c) => TextStyle(
      fontSize: fsmedium,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle mediumMedium(c) => TextStyle(
      fontSize: fsmedium,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
      letterSpacing: .0);
  TextStyle mediumSmi(c) => TextStyle(
      fontSize: fsmedium,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
      letterSpacing: .5);
  TextStyle mediumBold(c) => TextStyle(
      fontSize: fsmedium,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
      letterSpacing: 0);

  // Semi Fonts..........................................

  TextStyle SemiMediumLights(c) => TextStyle(
      fontSize: fssemi,
      fontFamily: ff,
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.none,
      letterSpacing: 0);

  TextStyle SemiMediumRegular(c) => TextStyle(
      fontSize: fssemi,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle SemiMediumMedium(c) => TextStyle(
      fontSize: fssemi,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle SemiMediumSmi(c) => TextStyle(
      fontSize: fssemi,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle SemiMediumBold(c) => TextStyle(
      fontSize: fssemi,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
      letterSpacing: 0);

  // Bold  Fonts..........................................

  TextStyle boldLights(c) => TextStyle(
      fontSize: fsbold,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.none,
      letterSpacing: 0);

  TextStyle boldRegular(c) => TextStyle(
      fontSize: fsbold,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      letterSpacing: .5);
  TextStyle boldMedium(c) => TextStyle(
      fontSize: fsbold,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle boldSmi(c) => TextStyle(
      fontSize: fsbold,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle boldBold(c) => TextStyle(
      fontSize: fsbold,
      fontFamily: ff,
      color: c,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
      letterSpacing: 0);
  TextStyle custom(c, fs, w) => TextStyle(
      fontSize: fs,
      fontFamily: ff,
      color: c,
      fontWeight: w,
      decoration: TextDecoration.none,
      letterSpacing: 0);

  //   Inputs decorations...............................................
  BoxShadow shadow() => BoxShadow(
        color: col.shadowcol,
        offset: Offset(
          4.5,
          2.10,
        ),
        blurRadius: 10.0,
        spreadRadius: 0.5,
      );
  BoxShadow shadow2() => BoxShadow(
        color: col.shadowcol,
        offset: Offset(
          3.0,
          1.0,
        ),
        blurRadius: 5.0,
        spreadRadius: 0.5,
      );
  BoxShadow shadowbottomnav() => BoxShadow(
        color: col.shadowcol,
        offset: Offset(
          0.0,
          0.0,
        ),
        blurRadius: 50.0,
        spreadRadius: 0.0,
      );

  pads(h, v) => EdgeInsets.symmetric(horizontal: h, vertical: v);
  loader(context) {
    showDialog(
        context: context,
        builder: (_) {
          return Container(
            height: 100.h,
            width: 100.w,
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text('Loading ...', style: sheet.mediumMedium(Colors.black))
                  ],
                )
              ],
            ),
          );
        });
  }
}
