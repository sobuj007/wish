import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../mainlayouts.dart';

class ChangeProfiles extends StatefulWidget {
  final u;
  ChangeProfiles({Key? key, this.u}) : super(key: key);

  @override
  State<ChangeProfiles> createState() => _ChangeProfilesState();
}

class _ChangeProfilesState extends State<ChangeProfiles> {
  late User udata;
  TextEditingController textin = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    udata = widget.u;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Text("Chosse your display name"),
            Container(
              width: 70.w,
              child: TextField(
                  controller: textin,
                  decoration: InputDecoration(
                      hintText: 'your display name',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.w),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black)))),
            ),
          ],
        )),
      ),
      floatingActionButton: GestureDetector(
        child: Container(
          height: 8.h,
          width: 90.w,
          color: Colors.amber,
          alignment: Alignment.center,
          child: Text("Hallo"),
        ),
        onTap: () {
          addnewuser(udata.uid, udata.phoneNumber);
        },
      ),
    );
  }

  addnewuser(uid, p) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userinfo')
        .add({
      'username': textin.text,
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
                  user: udata,
                )));
  }
}
