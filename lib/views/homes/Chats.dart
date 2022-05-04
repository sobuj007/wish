import 'package:Wish/views/chatroom/chatroom.dart';
import 'package:Wish/views/chatscontact/selectperson.dart';
import 'package:Wish/views/homes/Singelchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  late User u;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var room = [];
  var name = [];
  //var room = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    u = widget.user;
    // print(u.phoneNumber);
    //getData();

    getDocs();
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
          chatsitem()
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SelectPersonMessanger(
                        user: u,
                        sender: va['sender'],
                      )));
        },
        child: Icon(Icons.message),
      ),
    );
  }

  var va;
  Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("roominfo")
        .doc(u.phoneNumber)
        .collection('room')
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      // print(a['room']);
      room.add(a['roomid']);
      name.add(a['receiver']);
    }
    var v = await firebaseFirestore
        .collection('users')
        .doc(u.uid)
        .collection('userinfo')
        .get();
    va = v.docs[0].data() as Map;

    setState(() {
      // print(va['name'].toString());
      // print(room.toString());
    });
  }

  // Future<void> getData() async {
  //   final CollectionReference v =
  //       FirebaseFirestore.instance.collection('users');
  //   v.get().then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       print(doc.id);
  //       print(doc.exists);
  //     });
  //   });
  // }

  chatsitem() {
    var uids = u.uid.toString();
    return Expanded(
      child: ListView.builder(
        itemCount: room.length,
        itemBuilder: (BuildContext context, int i) {
          var d = room[i].toString();
          var n = name[i].toString();
          //  print('hello' + d.toString());
          Future.delayed(Duration(seconds: 2)).then((value) {});
          return Card(
            child: Container(
              height: 10.h,
              color: Colors.grey.shade100,
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore
                    .collection('chatroom')
                    .doc(d)
                    .collection('chat')
                    .orderBy(
                      'time',
                    )
                    .snapshots(),
                // initialData: initialData,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Map<String, dynamic> map =
                        snapshot.data?.docs[0].data() as Map<String, dynamic>;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 35,
                      ),
                      title: Text(map['receiver'].toString()),
                      subtitle: Text(
                        map['message'].toString(),
                        style: sheet.regularMedium(Colors.black),
                      ),
                      onTap: () {
                        print('object' + map['receiver'].toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Chatroom(
                                    roomid: d,
                                    receivername: n,
                                    receiverphone: map['rphone'],
                                    senderphone: u.phoneNumber,
                                    sender: '')));
                      },
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
