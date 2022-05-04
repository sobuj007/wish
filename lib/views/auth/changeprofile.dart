import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      body: Container(
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
    );
  }

  upadatedisplayname() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(udata.uid)
        .collection('userinfo')
        .doc()
        .update({'username': textin.text.toString()});
  }
}
