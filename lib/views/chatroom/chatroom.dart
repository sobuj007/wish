import 'package:Wish/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogflow_grpc/generated/google/protobuf/timestamp.pbjson.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Chatroom extends StatefulWidget {
  final roomid;
  final receivername;
  final receiverphone;
  final sender;
  final senderphone;

  Chatroom(
      {Key? key,
      required this.roomid,
      required this.receivername,
      required this.receiverphone,
      required this.senderphone,
      required this.sender})
      : super(key: key);

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  TextEditingController _inputs = new TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivername),
      ),
      body: SafeArea(
          child: Container(
        child: StreamBuilder(
          stream: firebaseFirestore
              .collection('chatroom')
              .doc(widget.roomid)
              .collection('chat')
              .orderBy("time", descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> map =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  if (map['rphone'].toString() != widget.receiverphone) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 35.w),
                        color: Colors.grey.shade100,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(map['message']),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 35.w),
                        alignment: Alignment.centerRight,
                        // color: Colors.grey.shade100,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(map['message']),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      )),
      floatingActionButton: Container(
        width: 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 70.w,
              child: TextField(
                  controller: _inputs,
                  decoration: InputDecoration(
                      hintText: 'your message',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.w),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black)))),
            ),
            Container(
              width: 20.w,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.emoji_emotions,
                    size: 30,
                  ),
                  SizedBox(),
                  GestureDetector(
                    child: Icon(
                      Icons.send,
                      size: 30,
                    ),
                    onTap: () {
                      sendmessage();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  //  Future getDocs() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(u.uid)
  //       .collection('chatroom')
  //       .get();
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i].data() as Map;
  //     // print(a['room']);
  //     room.add(a['room']);
  //   }
  //   setState(() {
  //     print(room.toString());
  //   });
  // }

  sendmessage() async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.roomid)
        .collection('chat')
        .add({
      'message': _inputs.text.toString(),
      'sender': widget.sender,
      'receiver': widget.receivername,
      'rphone': widget.receiverphone,
      'sphone': widget.senderphone,
      'attachment': '',
      'time': Timestamp.now(),
    });
    _inputs.clear();
  }
}


//  appBar: AppBar(
//         title: Text("data"),
//       ),
//       body: SafeArea(
//         child: Container(child: Text(";l;l")),
//       ),
//       floatingActionButton: Container(
//         color: Colors.grey,
//         height: 8.h,
//         alignment: Alignment.center,
//         child: Row(
//           children: [
//             Container(
//               color: Colors.orange,
//               child: TextField(
//                   controller: _inputs,
//                   decoration: InputDecoration(
//                       hintText: 'your message',
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.w),
//                       border: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1, color: Colors.black)))),
//             ),
//             Container(
//               width: 20.w,
//               padding: EdgeInsets.symmetric(horizontal: 1.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(
//                     Icons.emoji_emotions,
//                     size: 30,
//                   ),
//                   SizedBox(),
//                   GestureDetector(
//                     child: Icon(
//                       Icons.send,
//                       size: 30,
//                     ),
//                     onTap: () {
//                       sendmessage();
//                     },
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),