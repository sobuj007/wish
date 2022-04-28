import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/main.dart';

class Appbars {
  backappbar(t, context) {
    return Container(
      height: 15.w,
      padding: sheet.pads(4.w, 1.5.h),
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(96, 0, 0, 0), width: .3),
          boxShadow: [
            BoxShadow(
              color: col.shadowcol,
              offset: Offset(
                1.0,
                01.0,
              ),
              blurRadius: 50.0,
              spreadRadius: 0.0,
            )
          ]),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            t,
            style: sheet.mediumBold(Colors.black),
          )
        ],
      ),
    );
  }
}
