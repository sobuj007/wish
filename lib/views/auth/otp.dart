import 'package:Wish/views/auth/phones.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/views/mainlayouts.dart';

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
              Container(
                width: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: col.primary,
                    borderRadius: BorderRadius.circular(25)),
                child: GestureDetector(
                  onTap: () async {
                    verifyOTP();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'Verify',
                      style: sheet.mediumMedium(Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                height: 10.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Don't you recive any Code ?",
                      style: sheet.regularBold(Colors.black87),
                    ),
                    GestureDetector(
                      child: Text(
                        "Resend New Code",
                        style: sheet.mediumBold(Colors.black54),
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              )
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
      print(result);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainLayouts()));
    }).catchError((e) {
      print(e);
    });
  }
}
