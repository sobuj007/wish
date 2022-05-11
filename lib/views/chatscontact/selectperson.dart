import 'package:Wish/main.dart';
import 'package:Wish/views/chatroom/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Sharedpref/SharedPrefManager.dart';

class SelectPersonMessanger extends StatefulWidget {
  final sender;
  SelectPersonMessanger({Key? key, required this.sender}) : super(key: key);

  @override
  State<SelectPersonMessanger> createState() => _SelectPersonMessangerState();
}

class _SelectPersonMessangerState extends State<SelectPersonMessanger> {
  ScrollController sc = new ScrollController(initialScrollOffset: 5.0);
  List<Contact> contacts = [];

  bool searchs = false;
  late List? unfilddata = [Null];
  late List? data = [Null];
  late List? phonedata = [Null];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //u = widget.user;
    getpers();
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
  }

  getpers() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      getContacts();
    } else {
      await Permission.contacts.request();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => AlertDialog(
      //         title: Text('Permissions error'),
      //         content: Text('Please enable contacts access '
      //             'permission in system settings'),
      //         actions: <Widget>[
      //           CupertinoDialogAction(
      //             child: Text('OK'),
      //             onPressed: () => Navigator.of(context).pop(),
      //           )
      //         ],
      //       ));
    }
  }

  searchdemo(value) {
    print('valuses' + value.toString());
    var strisEiext = value.length > 0 ? true : false;
    if (strisEiext) {
      var filterdata = [];
      var filterphonedata = [];
      for (var i = 0; i < unfilddata!.length; i++) {
        String name = unfilddata![i].displayName.toString().toUpperCase();
        String phone = unfilddata![i].phones.toString().toUpperCase();
        print(name);
        if (name.contains(value.toString().toUpperCase()) ||
            phone.contains(value.toString().toUpperCase())) {
          print("object");
          filterdata.add(unfilddata![i].displayName);
          filterphonedata
              .add(unfilddata![i].phones!.elementAt(0).value.toString());
        }
      }
      setState(() {
        data = filterdata;
        phonedata = filterphonedata;
        print(data);
        print("phonedata");
        print(phonedata);
        searchs = true;
      });
    } else {
      setState(() {
        data = unfilddata;
        phonedata = unfilddata;
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

  getContacts() async {
    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var contact = await ContactsService.getContacts();
      setState(() {
        contacts = contact;
        print("Contact List " + contact.toList().toString());
        unfilddata = contact;
      });
    } else {
      print("Contact List: Permission denied ");
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to location data denied',
        details: null,
      );
    }
  }

  TextEditingController textin = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Select Contact's"), actions: []),
        body: SafeArea(
          child: Column(
            children: [
              (contacts.isEmpty)
                  ? Container()
                  : Row(
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
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
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

                                    addtoChatroom(d, receiver, rphone);
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
                  : (contacts.isEmpty)
                      ? Expanded(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'Loading . . .',
                              style: sheet.mediumBold(Colors.black),
                            )
                          ],
                        ))
                      : Expanded(
                          //height: 85.h,
                          child: ListView.builder(
                            controller: sc,
                            itemCount: contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact c = contacts[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      c.displayName.toString(),
                                      style: sheet.mediumBold(Colors.black),
                                    ),
                                    subtitle: Text(c.phones!
                                        .elementAt(0)
                                        .value
                                        .toString()),
                                    leading: (c.avatar! != null &&
                                            c.avatar!.length > 0)
                                        ? CircleAvatar(
                                            radius: 40,
                                            backgroundImage:
                                                MemoryImage(c.avatar!),
                                          )
                                        : CircleAvatar(
                                            radius: 40,
                                            child: Text(c.initials()),
                                          ),
                                    onTap: () {
                                      var d = c.phones!
                                              .elementAt(0)
                                              .value
                                              .toString() +
                                          '#' +
                                          phonenumbers.toString();
                                      print("object" + d.toString());
                                      var receiver = c.displayName.toString();
                                      var rphone = c.phones!
                                          .elementAt(0)
                                          .value
                                          .toString();

                                      addtoChatroom(d, receiver, rphone);
                                    },
                                  ),
                                  Container(
                                    width: 80.w,
                                    child: Divider(
                                      height: 1,
                                      color: Color.fromARGB(144, 158, 158, 158),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
            ],
          ),
        ));
  }

  addtoChatroom(d, receiver, rphone) async {
    var ud = uid.toString();
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(d.toString())
        .collection('chat')
        .add({});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ud.toString())
        .collection('chatroom')
        .add({'room': d.toString(), 'receiver': receiver});
    await FirebaseFirestore.instance
        .collection('roominfo')
        .doc(phonenumbers)
        .collection('room')
        .add({
      'roomid': d.toString(),
      'user1': rphone,
      'rname': receiver,
      'user2': phonenumbers,
      'uname': widget.sender
    });
    await FirebaseFirestore.instance
        .collection('roominfo')
        .doc(rphone)
        .collection('room')
        .add({'roomid': d.toString(), 'user1': rphone, 'user2': phonenumbers});

    print('success');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => Chatroom(
                roomid: d,
                receivername: receiver,
                receiverphone: rphone,
                senderphone: phonenumbers,
                sender: widget.sender,
              )),
    );
  }
}
