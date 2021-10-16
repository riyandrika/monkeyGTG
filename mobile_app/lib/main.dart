import 'package:flutter/material.dart';
import 'package:scdf_ibm/Screens/Welcome/welcome_screen.dart';
import 'package:scdf_ibm/constants.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Auth',
//       theme: ThemeData(
//         primaryColor: kPrimaryColor,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: WelcomeScreen(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "ALERT!",
        "Monkey spotted in your room!",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  void initState() {
    super.initState();
    showNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}
