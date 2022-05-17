import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final imags;
  final name;
  CallScreen({Key? key, this.imags, this.name}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(children: [
          Expanded(
            child: Image.network(widget.imags),
          )
        ]),
      ),
    );
  }
}
