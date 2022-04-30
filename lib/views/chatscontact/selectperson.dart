// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';

// import 'package:permission_handler/permission_handler.dart';

// class SelectPersonMessanger extends StatefulWidget {
//   SelectPersonMessanger({Key? key}) : super(key: key);

//   @override
//   State<SelectPersonMessanger> createState() => _SelectPersonMessangerState();
// }

// class _SelectPersonMessangerState extends State<SelectPersonMessanger> {
//   List<Contact> contacts = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getphonecontact();
//   }

//   getphonecontact() async {
//     List<Contact> contactsdata =
//         (await ContactsService.getContacts(withThumbnails: false)).toList();
//     setState(() {
//       contacts = contactsdata;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       child: ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             child: Text('lolo'),
//           );
//         },
//       ),
//     ));
//   }
// }
