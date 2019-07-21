import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/navigator/tab_navigator.dart' show TabNavigator;
import 'package:flutter/services.dart' show SystemUiOverlayStyle, SystemChrome;
import 'dart:io' show Platform;

void main() {
  runApp(MyApp());
  // ios默认透明不用加，自定义手机顶部黑条样式（Android沉浸式）
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // canvasColor: Colors.transparent
      ),
      home: TabNavigator(),
    );
  }
}


