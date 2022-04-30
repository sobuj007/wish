import 'package:Wish/main.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectPersonMessanger extends StatefulWidget {
  SelectPersonMessanger({Key? key}) : super(key: key);

  @override
  State<SelectPersonMessanger> createState() => _SelectPersonMessangerState();
}

class _SelectPersonMessangerState extends State<SelectPersonMessanger> {
  List<Contact> contacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
}
