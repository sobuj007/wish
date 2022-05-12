// import 'package:Wish/Sharedpref/SharedPrefManager.dart';
// import 'package:Wish/views/mainlayouts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class Subloader extends StatefulWidget {
//   final uid;
//   final phn;

//   Subloader({Key? key, this.uid, this.phn}) : super(key: key);

//   @override
//   State<Subloader> createState() => _SubloaderState();
// }

// class _SubloaderState extends State<Subloader> {
//   @override
//   void initState() {
//     super.initState();
//     adddata();
//   }

//   adddata() async {
//     print("object");
//     var uid = SharedPrefManager.getToken().toString();
//     var phone = SharedPrefManager.getphone().toString();
//     // var usersname = '';
//     // DocumentSnapshot variable = await FirebaseFirestore.instance
//     //     .collection('users')
//     //     .doc(uid)
//     //     .collection('userinfo')
//     //     .doc(phone)
//     //     .get();
//     // //  print('bal' + variable.toString());

//     // var name = variable['name'].toString();
//     var name;
//     // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//     //     .collection("users")
//     //     .doc(uid)
//     //     .collection('userinfo')
//     //     .doc(phone)
//     //     .s
//     // for (int i = 0; i < querySnapshot.docs.length; i++) {
//     //   var a = querySnapshot.docs[i].data() as Map;
//     //   print('amarname' + a['image'].toString());
//     // }
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('userinfo')
//         .get()
//         .then((value) {
//       value;
//       Map<String, dynamic> map = value.docs[0].data();
//       print(map['username'].toString());
//       name=
//     });
//     Future.delayed(Duration(seconds: 5));
//     print("heelo" + name.toString());
//     SharedPrefManager.setusername(name.toString());

//     Navigator.push(context, MaterialPageRoute(builder: (_) => MainLayouts()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(
//                 width: 2.w,
//               ),
//               Text("laoding ....subloader")
//             ],
//           )
//         ],
//       )),
//     );
//   }
// }
