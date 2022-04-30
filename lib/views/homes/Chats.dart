import 'package:Wish/views/chatscontact/selectperson.dart';
import 'package:Wish/views/homes/Singelchat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/main.dart';

class Chats extends StatefulWidget {
  Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            width: 100.w,
            color: col.primary,
            padding: sheet.pads(4.w, 2.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Wish",
                        style: sheet.SemiMediumMedium(Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                ]),
          ),
          chatsitem()
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (_) => SelectPersonMessanger()));
        },
        child: Icon(Icons.message),
      ),
    );
  }

  chatsitem() => Container(
        height: 80.h,
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: sheet.pads(3.w, 2.h),
                      leading: CircleAvatar(
                        backgroundColor: col.primary,
                        radius: 40,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                              'https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-shirt-white-background-person-gray-photo-placeholder-man-132818487.jpg'),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'data',
                            style: sheet.mediumSmi(Colors.black),
                          ),
                          Text(
                            'Hi,baby',
                            style: sheet.regularMedium(Colors.black),
                          ),
                        ],
                      ),
                      trailing: Text('4.30 PM'),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 80.w,
                      child: Divider(
                        height: 1,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Singelchat()));
                },
              );
            }),
      );
}
