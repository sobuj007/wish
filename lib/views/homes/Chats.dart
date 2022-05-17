import 'package:Wish/Sharedpref/SharedPrefManager.dart';
import 'package:Wish/views/allusers/allusers.dart';
import 'package:Wish/views/auth/changeprofile.dart';
import 'package:Wish/views/auth/phones.dart';
import 'package:Wish/views/auth/changepro.dart';
import 'package:Wish/views/chatroom/chatroom.dart';
import 'package:Wish/views/chatscontact/selectperson.dart';
import 'package:Wish/views/homes/Singelchat.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/main.dart';

import '../chatscontact/selectperson.dart';

class Chats extends StatefulWidget {
  final user;
  Chats({Key? key, this.user}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var room = [];
  var name = [];
  var phone;
  var names;
  var uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdatas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getuserdatas() async {
    uid = await SharedPrefManager.getToken();
    phone = await SharedPrefManager.getphone();
    print(uid);
    print(phone);

    getDocs();
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
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  var va;
  Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("roominfo")
        .doc(phone)
        .collection('room')
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      print('amarroom' + a['roomid'].toString());
      print("object " + a['user1']);
      room.add(a['roomid']);
      name.add(a['receiver']);
    }
    var v = await firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('userinfo')
        .get();
    va = v.docs[0].data() as Map;
    // print('what' + va);

    setState(() {
      // print(va['name'].toString());
      // print(room.toString());
    });
    print("roomlength" + room.length.toString());
  }

  changeit() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ChangeProfiles()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // leading: PhotoView(
        //   imageProvider: NetworkImage(profileimage),
        // ),
        leading: GestureDetector(
          child: Container(margin: sheet.pads(2.w, .2.h), child: imageforurl()),
          onTap: () {
            showdia();
          },
        ),
        centerTitle: true,
        title: Text(
          "Wish",
          style: sheet.SemiMediumMedium(Colors.white),
        ),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    // PopupMenuItem(
                    //   child: Text("Profile"),
                    //   value: 1,
                    //   onTap: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (_) => ChangePro()));
                    //   },
                    // ),
                    PopupMenuItem(
                      child: Text("Logout"),
                      value: 2,
                      onTap: () {
                        logoutdata();
                      },
                    )
                  ])
        ],
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/patts.jpg'),
                opacity: .3,
                fit: BoxFit.cover)),
        child: Column(
          children: [chatsitem()],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Allusers(
                      sender: names.toString(),
                      imgs: profileimage.toString())));
        },
        child: Icon(Icons.message),
      ),
    );
  }

  // getimage() => Container(
  //       width: 300,
  //       height: 100,
  //       child: FutureBuilder<String>(
  //         future: loadImage(),
  //         builder: (
  //           BuildContext context,
  //           AsyncSnapshot<String> snapshot,
  //         ) {
  //           if (snapshot.hasData) {
  //             return Text(snapshot.data.toString());
  //           } else {
  //             return Text('Loading data');
  //           }
  //         },
  //       ),
  //     );

  logoutdata() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userinfo')
        .doc(phone)
        .update({'fcmtoken': ''});
    FirebaseFirestore.instance
        .collection('alltoken')
        .doc(phone)
        .update({'fcmtoken': ''});
    await SharedPrefManager.setToken('');
    await SharedPrefManager.setFCMToken('');
    await SharedPrefManager.setUserLogin(false);
    await SharedPrefManager.setusername('');
    await SharedPrefManager.setphone('');
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Phones()), (route) => false);
  }

  imageforurl() {
    if (profileimage == null) {
      return Container();
    } else if (profileimage != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(profileimage.toString()),
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(profileimage.toString()),
      );
    }
  }

  contactimages() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userinfo')
        .doc(phone)
        .get();
    //  print('bal' + variable.toString());

    profileimage = variable['image'].toString();

    print("this is " + profileimage.toString());
    setState(() {});
    if (profileimage == null) {
      return Container();
    } else if (profileimage != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(profileimage.toString()),
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(profileimage.toString()),
      );
    }
  }

  chatsitem() {
    var uids = uid.toString();

    return Container(
      height: 80.h,
      child: ListView.builder(
        itemCount: room.length,
        itemBuilder: (BuildContext context, int i) {
          var d = room[i].toString();
          var n = name[i].toString();
          // print('hello' + d.toString());
          // print('reciver name' + n.toString());
          Future.delayed(Duration(seconds: 2)).then((value) {});
          return Container(
            height: 10.h,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            // color: Colors.grey.shade100,

            child: Card(
              child: StreamBuilder<QuerySnapshot>(
                  stream: firebaseFirestore
                      .collection('chatroom')
                      .doc(d)
                      .collection('chat')
                      .orderBy("time", descending: true)
                      .snapshots(),
                  // initialData: initialData,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data.toString().length == 0) {
                        return Center(
                          child: Text("Welcome"),
                        );
                      } else {
                        Map<String, dynamic> map = snapshot.data?.docs[0].data()
                            as Map<String, dynamic>;

                        // var n = (map['rphone'].toString() != phone)
                        //     ? map['receiver'].toString()
                        //     : map['sender'].toString();
                        // if (map['massage'].toString() ==
                        //     'welcome $n send you request') {
                        //   var v = (map['rphone'].toString() != phone)
                        //       ? map['rimage']
                        //       : map['simage'];

                        //   firstdialog(v, n);
                        // }

                        return ListTile(
                          leading: (map['rimage'] == null)
                              ? CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 30,
                                  child: Text(
                                    'w',
                                    style: sheet.boldBold(Colors.white),
                                  ),
                                )
                              : (map['rphone'].toString() != phone)
                                  ? CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          map['rimage'].toString()),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          map['simage'].toString()),
                                    ),
                          title: Text((map['rphone'].toString() != phone)
                              ? map['receiver'].toString()
                              : map['sender'].toString()),
                          subtitle: (map['message'].toString() != null)
                              ? Text(
                                  map['message'].toString(),
                                  style: sheet.regularMedium(Colors.black),
                                )
                              : Text(''),
                          onTap: () {
                            print('object' + map['receiver'].toString());

                            print(n.toString() +
                                "name.toString() + phone.toString()");
                            print('objectr' +
                                map['rimage'].toString().toString());
                            print('objectU' + profileimage.toString());

                            //FirebaseMessaging.instance.subscribeToTopic('$d');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Chatroom(
                                          roomid: d,
                                          receivername:
                                              map['receiver'].toString(),
                                          receiverphone: map['rphone'],
                                          receiverimg: map['rimage'].toString(),
                                          senderphone: phone,
                                          sender: names,
                                          senderimg: profileimage.toString(),
                                        )));
                          },
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
            ),
          );
        },
      ),
    );
  }

  showdia() => showDialog(
      context: context,
      builder: (_) {
        return Container(
          color: Colors.white,
          margin: sheet.pads(3.w, 5.h),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(profileimage.toString()),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 6.h,
                width: 70.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: .5, color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    names,
                    style: sheet.mediumBold(Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 6.h,
                width: 70.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: .5, color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    phone,
                    style: sheet.mediumBold(Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      });
  firstdialog(images, name) => showDialog(
      context: context,
      builder: (_) {
        return Container(
          color: Colors.white,
          margin: sheet.pads(3.w, 5.h),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(images.toString()),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 6.h,
                width: 70.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: .5, color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    style: sheet.mediumBold(Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 6.h,
                width: 70.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: .5, color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    phone,
                    style: sheet.mediumBold(Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
