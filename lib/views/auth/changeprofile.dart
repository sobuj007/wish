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

class ChangeProfiles extends StatefulWidget {
  final u;
  ChangeProfiles({Key? key, this.u}) : super(key: key);

  @override
  State<ChangeProfiles> createState() => _ChangeProfilesState();
}

class _ChangeProfilesState extends State<ChangeProfiles> {
  late User udata;
  TextEditingController textin = new TextEditingController();
  var fcmtoken;
  @override
  void initState() {
    // TODO: implement initState
    udata = widget.u;
    tokensdata();
    super.initState();
  }

  tokensdata() async {
    fcmtoken = await SharedPrefManager.getFCMToken();
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        print(_photo);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  var finalpath = '';
  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    var imagefile = FirebaseStorage.instance.ref('files').child('$fileName');
    UploadTask task = imagefile.putFile(_photo!);
    TaskSnapshot tsnapshot = await task;
    finalpath = await tsnapshot.ref.getDownloadURL();

    print(finalpath);
    Future.delayed(Duration(seconds: 3));
    setState(() {});
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
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                  child: _photo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _photo!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
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
      floatingActionButton: (finalpath == '')
          ? Container()
          : GestureDetector(
              child: Container(
                height: 8.h,
                width: 90.w,
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text(
                  "Add",
                  style: sheet.mediumMedium(Colors.black),
                ),
              ),
              onTap: () {
                addnewuser(udata.uid, udata.phoneNumber, context);
              },
            ),
    );
  }

  addnewuser(uid, p, context) async {
    String fcmtok = await SharedPrefManager.getFCMToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userinfo')
        .doc(p)
        .set({
      'username': textin.text,
      'phone': p.toString(),
      'uid': uid.toString(),
      'image': finalpath.toString(),
      'fcmtoken': fcmtok.toString(),
    });
    await FirebaseFirestore.instance.collection('allusers').doc().set({
      'username': textin.text,
      'phone': p,
      'uid': uid.toString(),
      'image': finalpath.toString(),
    });
    await FirebaseFirestore.instance
        .collection('alltokens')
        .doc(p)
        .set({'fcmtoken': fcmtoken});
    print('user creation success');
    await SharedPrefManager.setToken(uid);
    await SharedPrefManager.setUserLogin(true);
    await SharedPrefManager.setusername(udata.displayName);
    await SharedPrefManager.setphone(udata.phoneNumber);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Welcome ...'),
      backgroundColor: Colors.lightGreen,
    ));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainLayouts(
                  user: udata,
                )));
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
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
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
