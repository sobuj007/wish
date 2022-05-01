import 'package:Wish/views/mainlayouts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/main.dart';
import 'package:Wish/views/appbars.dart';
import 'package:Wish/views/auth/otp.dart';

class Phones extends StatefulWidget {
  Phones({Key? key}) : super(key: key);

  @override
  State<Phones> createState() => _PhonesState();
}

class _PhonesState extends State<Phones> {
  var countrycode = '+60';
  TextEditingController phoneNumber = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    super.initState();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationID = "";
  void loginWithPhone(pho) async {
    auth.verifyPhoneNumber(
      phoneNumber: pho,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
          print(credential.toString());
        });
      },
      timeout: Duration(seconds: 30),
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        //otpVisibility = true;
        verificationID = verificationId;
        print('object');
        print(verificationId);
        print(resendToken);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OtpVerification(
                      phonesvid: verificationID,
                    )));
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Appbars().backappbar('Register Number', context),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(
                  height: 10.w,
                ),
                Container(
                  height: 16.h,
                  width: 50.w,
                  color: Colors.green,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Add your phone number and then we will sent you a otp code for protection purpose.',
                  style: sheet.mediumBold(Colors.black54),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Row(
                  children: [
                    phone(),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneNumber,
                        decoration: InputDecoration(
                            contentPadding: sheet.pads(2.0, 0.0),
                            hintText: 'Enter your phone Number',
                            hintStyle: sheet.regularMedium(Colors.black54),
                            label: Text('Number'),
                            labelStyle: sheet.mediumMedium(Colors.blue)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      )),
      bottomNavigationBar: GestureDetector(
        child: Container(
            width: 100.w,
            margin: sheet.pads(5.w, .5.h),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            height: 6.h,
            alignment: Alignment.center,
            child: Text(
              'Next',
              style: sheet.mediumMedium(Colors.white),
            )),
        onTap: () {
          if (phoneNumber.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please Enter Valid Data'),
              backgroundColor: Colors.red,
            ));
          } else {
            var pho = countrycode + phoneNumber.text.toString();
            print(pho);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Checking Phone Number ...'),
              backgroundColor: Colors.green,
            ));
            // sheet.loader(context);
            loginWithPhone(pho);
          }
        },
      ),
    );
  }

  phone() => Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: CountryCodePicker(
          onChanged: (v) {
            countrycode = v.toString();
            print(countrycode);
          },
          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
          initialSelection: 'My',
          favorite: ['+60', 'My'],
          // optional. Shows only country name and flag
          showCountryOnly: false,
          // optional. Shows only country name and flag when popup is closed.
          showOnlyCountryWhenClosed: false,
          // optional. aligns the flag and the Text left
          alignLeft: false,
        ),
      );
}
