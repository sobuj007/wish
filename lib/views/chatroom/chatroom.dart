import 'package:Wish/main.dart';
import 'package:Wish/views/mainlayouts.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogflow_grpc/generated/google/protobuf/timestamp.pbjson.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Sharedpref/SharedPrefManager.dart';

class Chatroom extends StatefulWidget {
  final roomid;
  final receivername;
  final receiverphone;
  final receiverimg;
  final sender;
  final senderphone;
  final senderimg;

  Chatroom({
    Key? key,
    required this.roomid,
    required this.receivername,
    required this.receiverphone,
    this.receiverimg,
    required this.senderphone,
    required this.sender,
    this.senderimg,
  }) : super(key: key);

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  TextEditingController _inputs = new TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  String appId = '020f338d91ba4be49e1f22232627028b';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.senderimg);
    print(widget.receiverimg);
    getuserdatas();
    // loadImage();
  }

  var phonenumbers;
  var names;
  var uid;
  getuserdatas() async {
    uid = await SharedPrefManager.getToken();
    phonenumbers = await SharedPrefManager.getphone();
    names = await SharedPrefManager.getusername();
    print(names);
    print(phonenumbers);
    print(uid);
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
          .doc(phonenumbers)
          .get();
      //  print('bal' + variable.toString());

      profileimage = variable['image'].toString();

      print("this is " + profileimage.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(appId);
    await _engine.enableAudio();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(
        '9a87cf7076444e3d867b727b2b65793d', 'testing', null, 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainLayouts()),
                (route) => false);
          },
        ),
        title: Text((widget.receiverphone != phonenumbers)
            ? widget.receivername
            : widget.sender),
        actions: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.phone),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 3.w),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(Icons.videocam),
              ),
            ),
            onTap: () {
              showdia();
            },
          ),
        ],
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
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/patts.jpg'),
                        opacity: .3,
                        fit: BoxFit.cover)),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (map['sphone'].toString() == phonenumbers) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 35.w),
                          alignment: Alignment.centerRight,
                          child: Card(
                            color: Color.fromARGB(79, 240, 241, 241),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                map['message'],
                                style: sheet.mediumBold(Colors.black),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 35.w),
                          alignment: Alignment.centerLeft,
                          // color: Colors.grey.shade100,
                          child: Card(
                            color: Colors.white54,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(map['message'],
                                  style: sheet.mediumBold(Colors.black)),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
      )),
      floatingActionButton: Container(
        height: 8.h,
        color: Colors.transparent,
        width: 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 65.w,
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
              width: 25.w,
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.send,
                        size: 30,
                      ),
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
    print('objectr' + widget.receiverimg.toString());
    print('objectU' + widget.senderimg.toString());
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.roomid)
        .collection('chat')
        .add({
      'message': _inputs.text.toString(),
      'sender': names.toString(),
      'receiver': widget.receivername,
      'rphone': widget.receiverphone,
      'rimage': widget.receiverimg,
      'sphone': phonenumbers,
      'simage': widget.senderimg,
      'attachment': '',
      'time': Timestamp.now(),
    });
    _inputs.clear();
  }

  showdia() => showDialog(
      context: context,
      builder: (_) {
        return Container(
            height: 100.h,
            color: Colors.white,
            child: Stack(
              children: [
                Center(
                  child: _remoteVideo(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 100,
                    height: 150,
                    child: Center(
                      child: _localUserJoined
                          ? RtcLocalView.SurfaceView()
                          : CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ));
      });

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: 'Testing',
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 2.h,
            color: Colors.black),
        textAlign: TextAlign.center,
      );
    }
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
