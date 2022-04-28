import 'package:Wish/views/auth/phones.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/views/mainlayouts.dart';

import '../../main.dart';

class OtpVerification extends StatefulWidget {
  final phones;

  OtpVerification({Key? key, this.phones}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  var otp;
  late String _verificationCode;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationID = "";
  @override
  void initState() {
    super.initState();
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp.text);

    await auth.signInWithCredential(credential).then(
      (value) {
        print("You are logged in successfully");
        // Fluttertoast.showToast(
        //   msg: "You are logged in successfully",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.red,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      },
    ).whenComplete(
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainLayouts(),
          ),
        );
      },
    );
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
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => MainLayouts()));
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
}
