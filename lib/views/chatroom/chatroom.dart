import 'package:Wish/main.dart';
import 'package:Wish/notifiy/Messaging.dart';
import 'package:Wish/views/callerscreen/CallScreen.dart';
import 'package:Wish/views/mainlayouts.dart';
import 'package:Wish/views/pages/index.dart';
import 'package:Wish/views/pages/voiceCall.dart';
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
import '../pages/call.dart';

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
        title: Text(widget.receivername),
        actions: [
          GestureDetector(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.phone),
              ),
            ),
            onTap: () async {
              var channelname = 'testchannel';

              if (channelname.isNotEmpty) {
                // await for camera and mic permissions before pushing video page
                await _handleCameraAndMic(Permission.camera);
                await _handleCameraAndMic(Permission.microphone);
                // push video page with given channel name
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoiceCall(
                      channelName: channelname,
                      role: ClientRole.Broadcaster,
                      image: widget.receiverimg,
                    ),
                  ),
                );
              }
            },
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 3.w),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(Icons.videocam),
              ),
            ),
            onTap: () async {
              var channelname = 'testchannel';

              if (channelname.isNotEmpty) {
                // await for camera and mic permissions before pushing video page
                await _handleCameraAndMic(Permission.camera);
                await _handleCameraAndMic(Permission.microphone);
                // push video page with given channel name
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallPage(
                      channelName: channelname,
                      role: ClientRole.Broadcaster,
                    ),
                  ),
                );
              }
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
                      if (_inputs.text == '') {
                      } else {
                        sendmessage();
                      }
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

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Messaging m = Messaging();
  sendmessage() async {
    print('objectr' + widget.receiverimg.toString());
    print('objectU' + widget.senderimg.toString());
    String token = await SharedPrefManager.getFCMToken();
    print("lol " + token);

    var tok = '';

    print(widget.receiverphone);

    var b = widget.receiverphone;
    await FirebaseFirestore.instance
        .collection("alltokens")
        .doc(b)
        .snapshots()
        .listen((event) {
      setState(() {
        tok = event.get("fcmtoken");
        print("bal" + tok);
      });
    });
    var title = "Wish $b";
    var body = _inputs.text.toString();

    m.sendtoSingel(title, body, tok);

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
      'sfcmtoken': token,
      'attachment': '',
      'time': Timestamp.now(),
    });
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
  shoaudioCalldia() => showDialog(
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
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Container(
                //     width: 100,
                //     height: 150,
                //     child: Center(
                //       child: _localUserJoined
                //           ? RtcLocalView.SurfaceView()
                //           : CircularProgressIndicator(),
                //     ),
                //   ),
                // ),
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
      var name = widget.receivername;
      return Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(color: Colors.black87),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.receiverimg),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'Calling $name',
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 2.h,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 35,
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 35,
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  // sensdnotification() async {
  //   var tok = '';

  //   print(widget.receiverphone);
  //   await FirebaseFirestore.instance
  //       .collection("alltokens")
  //       .doc(widget.receiverphone)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       tok = event.get("fcmtoken");
  //       print("bal" + tok);
  //     });
  //   });
  //   print(tok);
  //   // Messaging().sendtoSingel(widget.receivername, _inputs.text.toString(), tok);
  // }
}
