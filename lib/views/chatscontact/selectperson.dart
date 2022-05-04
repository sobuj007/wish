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

class SelectPersonMessanger extends StatefulWidget {
  final user;
  final sender;
  SelectPersonMessanger({Key? key, this.user, required this.sender})
      : super(key: key);

  @override
  State<SelectPersonMessanger> createState() => _SelectPersonMessangerState();
}

class _SelectPersonMessangerState extends State<SelectPersonMessanger> {
  ScrollController sc = new ScrollController(initialScrollOffset: 5.0);
  List<Contact> contacts = [];
  late User u;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    u = widget.user;
    getpers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Select Contact's"), actions: []),
        body: SafeArea(
          child: Column(
            children: [
              (contacts.isEmpty)
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
                  : Container(
                      height: 85.h,
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
                                subtitle: Text(
                                    c.phones!.elementAt(0).value.toString()),
                                leading: (c.avatar! != null &&
                                        c.avatar!.length > 0)
                                    ? CircleAvatar(
                                        radius: 40,
                                        backgroundImage: MemoryImage(c.avatar!),
                                      )
                                    : CircleAvatar(
                                        radius: 40,
                                        child: Text(c.initials()),
                                      ),
                                onTap: () {
                                  var d =
                                      c.phones!.elementAt(0).value.toString() +
                                          '#' +
                                          u.phoneNumber.toString();
                                  print("object" + d.toString());
                                  var receiver = c.displayName.toString();
                                  var rphone =
                                      c.phones!.elementAt(0).value.toString();

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
    var ud = u.uid.toString();
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
        .doc(u.phoneNumber)
        .collection('room')
        .add({
      'roomid': d.toString(),
      'user1': rphone,
      'rname': receiver,
      'user2': u.phoneNumber,
      'uname': u.displayName
    });
    await FirebaseFirestore.instance
        .collection('roominfo')
        .doc(rphone)
        .collection('room')
        .add({'roomid': d.toString(), 'user1': rphone, 'user2': u.phoneNumber});

    print('success');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Chatroom(
                  roomid: d,
                  receivername: receiver,
                  receiverphone: rphone,
                  senderphone: u.phoneNumber,
                  sender: widget.sender,
                )));
  }
}
