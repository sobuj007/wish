import 'package:Wish/views/contact_calls/selectperson.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/main.dart';

class Call extends StatefulWidget {
  Call({Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            width: 100.w,
            color: col.primary,
            padding: sheet.pads(4.w, 2.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Wish",
                        style: sheet.SemiMediumMedium(Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                ]),
          ),
          Container(
            height: 75.h,
            child: Center(
              child: Text(
                'Call',
                style: sheet.mediumBold(Colors.black),
              ),
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => SelectPersonCall()));
        },
        child: Icon(Icons.call),
      ),
    );
  }
}
