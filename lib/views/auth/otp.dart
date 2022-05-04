import 'package:Wish/views/auth/changeprofile.dart';
import 'package:Wish/views/auth/phones.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/views/mainlayouts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class OtpVerification extends StatefulWidget {
  final phonesvid;

  OtpVerification({Key? key, required this.phonesvid}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String otp = '';
  late String verificationCode;
  FirebaseAuth auth = FirebaseAuth.instance;
  var userdata;
  String verificationID = "";
  @override
  void initState() {
    super.initState();
    verificationID = widget.phonesvid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: sheet.pads(5.w, 2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40.w,
                  height: 25.h,
                  color: Colors.greenAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Verification",
                  style: sheet.custom(Colors.black, 26.0, FontWeight.w800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Enter Your code number",
                  style: sheet.mediumBold(Colors.black45),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: col.shadowcol,
                      offset: Offset(
                        3.0,
                        1.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                    )
                  ],
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OtpTextField(
                      numberOfFields: 6,
                      borderColor: col.primary,
                      focusedBorderColor: col.primary,

                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      margin: EdgeInsets.all(0),

                      textStyle: sheet.mediumBold(Colors.black),
                      borderRadius: BorderRadius.circular(15),

                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) {
                        otp = verificationCode;
                        setState(() {});
                      }, // end onSubmit
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  sheet.loader(context);
                  verifyOTP();
                },
                child: Container(
                  width: 100.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: col.primary,
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'Verify',
                      style: sheet.mediumMedium(Colors.white),
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: 10.h,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Text(
              //         "Don't you recive any Code ?",
              //         style: sheet.regularBold(Colors.black87),
              //       ),
              //       GestureDetector(
              //         child: Text(
              //           "Resend New Code",
              //           style: sheet.mediumBold(Colors.black54),
              //         ),
              //         onTap: () {},
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      )),
    );
  }

  verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp.toString());
    print(credential);
    print('Problem');

    //await auth.signInWithCredential(credential).then((value) => {print(value)});
    await auth.signInWithCredential(credential).then((result) {
      // print(result.additionalUserInfo!.isNewUser.toString());
      // print(result.user!.uid.toString());
      // print(result.user!.phoneNumber.toString());

      var uid = result.user!.uid.toString();
      var name = result.user!.displayName.toString();
      var phone = result.user!.phoneNumber.toString();
      userdata = result.user;
      print(userdata);
      Navigator.pop(context);

      if (result.additionalUserInfo!.isNewUser == true) {
        // if (name.isEmpty) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ChangeProfiles(
        //                 u: userdata,
        //               )));
        // } else {
        //   addnewuser(uid, phone, name);
        // }
        addnewuser(uid, phone, name);
      } else {
        checkuser(uid);
      }
    }).catchError((e) {
      print(e);
    });
  }

  addnewuser(uid, p, n) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userinfo')
        .add({
      'username': '',
      'phone': p.toString(),
      'uid': uid.toString(),
      'image': '',
    });
    print('user creation success');

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Welcome ...'),
      backgroundColor: Colors.green,
    ));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainLayouts(
                  user: userdata,
                )));
  }

  bool? exist = false;
  checkuser(uid) async {
    try {
      await FirebaseFirestore.instance.doc('users/$uid').get().then((doc) {
        exist = doc.exists;
        print(exist);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Welcome ...'),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainLayouts(
                      user: userdata,
                    )));
      });
      //return exist;
    } catch (e) {
      print(e);
      //return false;
    }
  }
}
