import 'package:Wish/main.dart';
import 'package:Wish/views/chatroom/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Sharedpref/SharedPrefManager.dart';

class Allusers extends StatefulWidget {
  final sender;
  final imgs;
  Allusers({Key? key, required this.sender, this.imgs}) : super(key: key);

  @override
  State<Allusers> createState() => _AllusersState();
}

class _AllusersState extends State<Allusers> {
  ScrollController sc = new ScrollController(initialScrollOffset: 5.0);
  List<Contact> contacts = [];

  bool searchs = false;
  late AsyncSnapshot<QuerySnapshot> unfilddata;
  late AsyncSnapshot<QuerySnapshot> d1;
  late List? data = [Null];
  late List? phonedata = [Null];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //u = widget.user;
    // getpers();
    getuserdatas();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var phonenumbers;
  var names;
  var uid;
  getuserdatas() async {
    uid = await SharedPrefManager.getToken();
    phonenumbers = await SharedPrefManager.getphone();
    print("phone" + phonenumbers);
    names = widget.sender.toString();
    print(names);
  }

  // searchdemo(value) {
  //   var strisEiext = value.length > 0 ? true : false;
  //   if (strisEiext) {
  //     var filterdata = [];
  //     //  var filterphonedata = [];

  //     for (var i = 0; i < unfilddata.data!.docs.length; i++) {
  //       Map<String, dynamic> map =
  //           unfilddata.data!.docs[i].data() as Map<String, dynamic>;
  //       print(map['username']);
  //       var v = map['username'].toString();

  //       String name = v.toString().toUpperCase();
  //       // //  String phone = unfilddata![i].phones.toString().toUpperCase();
  //       print(name);
  //       if (name.contains(value.toString().toUpperCase())) {
  //         print("object" + v);
  //         filterdata.add(v);
  //       }
  //     }
  //     setState(() {
  //       data = filterdata;
  //       // phonedata = filterphonedata;
  //       print(data);

  //       searchs = true;
  //     });
  //   } else {
  //     setState(() {
  //       // d1 = unfilddata;

  //       // print(data);
  //       searchs = false;
  //     });
  //   }
  // }

  searchdemo(value) {
    print('valuses' + value.toString());
    var strisEiext = value.length > 0 ? true : false;
    if (strisEiext) {
      var filterdata = [];
      var filterphonedata = [];
      for (var i = 0; i < unfilddata.data!.docs.length; i++) {
        String name = unfilddata.data!.docs[i].data().toString().toUpperCase();
        //String phone = unfilddata![i].phones.toString().toUpperCase();
        print(name);
        if (name.contains(value.toString().toUpperCase())) {
          print("object");
          filterdata.add(unfilddata.data!.docs[i]);
          // filterphonedata
          //     .add(unfilddata![i].phones!.elementAt(0).value.toString());
        }
      }
      setState(() {
        data = filterdata;
        // phonedata = filterphonedata;
        print(data);
        //print("phonedata");
        //  print(phonedata);
        searchs = true;
      });
    } else {
      setState(() {
        data = unfilddata.data!.docs;
        // phonedata = unfilddata;
        print(data);
        searchs = false;
      });
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  TextEditingController textin = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Find Friends"), actions: []),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 90.w,
                      margin: sheet.pads(3.w, 2.h),
                      child: TextField(
                        controller: textin,
                        autofocus: false,
                        onChanged: (value) {
                          searchdemo(value);
                        },
                        decoration: InputDecoration(
                          contentPadding: sheet.pads(5.0.w, 0.10.h),
                          hintText: "search contact",
                          suffixIcon: Icon(Icons.search),
                          hintStyle: sheet.regularBold(Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                        ),
                      )),
                ],
              ),
              searchs
                  ? (data != null)
                      ? Container(
                          height: 35.h,
                          margin: sheet.pads(2.w, 5.0.w),
                          child: ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  leading: Container(
                                    width: 10.w,
                                    height: 12.w,
                                    decoration: BoxDecoration(
                                        // image: DecorationImage(
                                        //     image: AssetImage(
                                        //         'assets/' + pimg[index]),
                                        //     fit: BoxFit.cover),
                                        ),
                                  ),
                                  title: Text(data![index].toString()),
                                  subtitle: Text(phonedata![index].toString()),
                                  onTap: () {
                                    var pd = phonedata![index]
                                        .toString()
                                        .replaceAll(' ', '')
                                        .replaceAll('-', '');
                                    var d = pd.toString() +
                                        '#' +
                                        phonenumbers.toString();
                                    print("object" + d.toString());
                                    var receiver = data![index].toString();
                                    var rphone = phonedata![index].toString();

                                    //  addtoChatroom(d, receiver, rphone);
                                  },
                                );
                              }),
                        )
                      : Center(
                          child: Text(
                            "Nothing Found",
                            style: sheet.regularBold(Colors.black),
                          ),
                        )
                  : chatsitem()
            ],
          ),
        ));
  }

  addtoChatroom(d, receiver, rphone, rimg) async {
    var ud = uid.toString();
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(d)
        .collection('chat')
        .add({
      'message': 'welcome,$names send you request',
      'sender': names.toString(),
      'receiver': receiver,
      'rphone': rphone,
      'rimage': rimg,
      'sphone': phonenumbers,
      'simage': widget.imgs,
      'attachment': '',
      'time': Timestamp.now(),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ud.toString())
        .collection('chatroom')
        .add({
      'room': d.toString(),
      'user1': receiver,
      'u1phone': rphone,
      'u1image': rimg,
      'user2': receiver,
      'u2phone': phonenumbers,
      'u2image': widget.imgs,
    });
    await FirebaseFirestore.instance
        .collection('roominfo')
        .doc(phonenumbers)
        .collection('room')
        .add({
      'roomid': d.toString(),
      'user1': rphone,
      'rname': receiver,
      'rimage': rimg,
      'user2': phonenumbers,
      'uname': widget.sender,
      'uimage': widget.imgs
    });
    await FirebaseFirestore.instance
        .collection('roominfo')
        .doc(rphone)
        .collection('room')
        .add({
      'roomid': d.toString(),
      'user1': rphone,
      'rname': receiver,
      'rimage': rimg,
      'user2': phonenumbers,
      'uname': widget.sender,
      'uimage': widget.imgs
    });

    // FirebaseMessaging fmassage = FirebaseMessaging.instance;

    // fmassage.subscribeToTopic(d.toString());
    // print('success');
    // print(d.replaceAll(new RegExp(r'[^\w\s]+'), ''));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => Chatroom(
                roomid: d,
                receivername: receiver,
                receiverphone: rphone,
                receiverimg: rimg,
                senderphone: phonenumbers,
                sender: widget.sender,
                senderimg: widget.imgs,
              )),
    );
  }

  chatsitem() {
    var uids = uid.toString();
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('allusers').snapshots(),
        // initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: CircularProgressIndicator(),
            );
          } else {
            unfilddata = snapshot;

            print('hello' + unfilddata.toString());

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                unfilddata = snapshot;
                if (map['phone'].toString() != phonenumbers) {
                  return Container(
                    margin: sheet.pads(2.w, 2.h),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          backgroundImage: NetworkImage(map['image'].toString())

                          // Text(
                          //   map['image'].toString(),
                          //   style: sheet.boldBold(Colors.white),
                          // ),
                          ),
                      title: Text(
                        map['username'].toString(),
                        style: sheet.mediumBold(Colors.black),
                      ),
                      // subtitle: Text(
                      //   map['phone'].toString(),
                      //   style: sheet.regularMedium(Colors.black),
                      // ),
                      trailing: CircleAvatar(
                        radius: 15,
                        child: Icon(Icons.add),
                      ),
                      onTap: () {
                        //  print('object' + map['phone'].toString());

                        // print(
                        //     n.toString() + "name.toString() + phone.toString()");
                        var d = map['phone'].toString() +
                            '#' +
                            phonenumbers.toString();
                        print(d.toString());
                        addtoChatroom(d, map['username'].toString(),
                            map['phone'], map['image'].toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Chatroom(
                                      roomid: d,
                                      receivername: map['username'].toString(),
                                      receiverphone: map['phone'].toString(),
                                      receiverimg: map['image'].toString(),
                                      senderphone: phonenumbers,
                                      sender: names.toString(),
                                      senderimg: widget.imgs.toString(),
                                    )));
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}
