import 'package:bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'homes/BusniessChat.dart';
import 'homes/Call.dart';
import 'homes/Chats.dart';

class MainLayouts extends StatefulWidget {
  final user;
  MainLayouts({Key? key, this.user}) : super(key: key);

  @override
  State<MainLayouts> createState() => _MainLayoutsState();
}

class _MainLayoutsState extends State<MainLayouts> {
  int selectindex = 0;
  List<Widget> wd = [Chats(), BusniessChats(), Call()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: wd[selectindex]),
        bottomNavigationBar: BottomNavBar(
          showElevation: true,
          selectedIndex: selectindex,
          onItemSelected: (index) {
            setState(() => selectindex = index);
          },
          items: <BottomNavBarItem>[
            BottomNavBarItem(
              title: "Chat's",
              icon: const Icon(Icons.message),
              activeColor: Colors.blue.shade300,
              inactiveColor: Colors.black,
              // activeBackgroundColor: Colors.blue.shade300,
            ),
            BottomNavBarItem(
              title: "Busniess Chat's",
              icon: const Icon(Icons.business),
              activeColor: Colors.blue.shade300,
              inactiveColor: Colors.black,
              // activeBackgroundColor: Colors.blue.shade300,
            ),
            BottomNavBarItem(
              title: 'Call',
              icon: const Icon(Icons.phone),
              inactiveColor: Colors.black,
              activeColor: Colors.blue.shade300,
              // activeBackgroundColor: Colors.blue.shade300,
            ),
          ],
        ));
  }
}
