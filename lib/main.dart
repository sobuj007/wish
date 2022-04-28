import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:Wish/views/splash.dart';
import 'package:Wish/views/xtrawidget/ColorsData.dart';
import 'package:Wish/views/xtrawidget/styles.dart';

Style sheet = new Style();
ColorsData col = new ColorsData();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChatsApp());
}

class ChatsApp extends StatelessWidget {
  const ChatsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return Splash();
        },
      ),
    );
  }
}
