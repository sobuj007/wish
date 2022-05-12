import 'dart:convert';
import 'dart:io';

import 'package:Wish/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Sharedpref/SharedPrefManager.dart';
import '../mainlayouts.dart';

class ChangePro extends StatefulWidget {
  ChangePro({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePro> createState() => _ChangeProState();
}

class _ChangeProState extends State<ChangePro> {
  late User udata;
  TextEditingController textin = new TextEditingController();
  var phone;
  var names;
  var uid;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  getuserdatas() async {
    uid = await SharedPrefManager.getToken();
    phone = await SharedPrefManager.getphone();
    print(uid);
    print(phone);

    loadImage();
    getusername();
  }

  getusername() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userinfo')
        .doc(phone)
        .get();
    names = variable['username'].toString();
    await SharedPrefManager.setusername(names);

    print(variable['username'].toString());
    // var collection = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(uid)
    //     .collection('userinfo');
    // var docSnapshot = await collection.doc(phone).get();
    // if (docSnapshot.exists) {
    //   Map<String, dynamic> data = docSnapshot.data()!;

    //   // You can then retrieve the value from the Map like this:
    //   var name = data['name'];
    //   print('this name' + name.toString());
    // }
  }

  dynamic profileimage;
  loadImage() async {
    //current user id

    try {
      //collect the image name\
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('userinfo')
          .doc(phone)
          .get();
      //  print('bal' + variable.toString());

      profileimage = variable['image'].toString();

      print("this is " + profileimage.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(profileimage.toString()),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text("Chosse your display name"),
            SizedBox(
              height: 2.h,
            ),
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
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        //imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      // imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
