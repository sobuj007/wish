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
            padding: EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phone Number',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '1-800-266-0172',
                        style: sheet.mediumMedium(Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Location',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          '(Headquarters) One Sansome Street, 33rd Floor, San Francisco, CA 94104.',
                          style: sheet.mediumMedium(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Time available',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          ' 10am – 10pm',
                          style: sheet.mediumMedium(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          'support@wish.com',
                          style: sheet.mediumMedium(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Website',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          'www.wish.com',
                          style: sheet.mediumMedium(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Facebook',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          'www.facebook.com/wish/',
                          style: sheet.mediumMedium(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Instagram',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          'www.instagram.com/wish/',
                          style: sheet.mediumMedium(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Twitter',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                            Text(
                              ':',
                              style: sheet.mediumMedium(Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          'twitter.com/wishshopping',
                          style: sheet.mediumMedium(Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, CupertinoPageRoute(builder: (_) => SelectPersonCall()));
      //   },
      //   child: Icon(Icons.call),
      // ),
    );
  }
}
