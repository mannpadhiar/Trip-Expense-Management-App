import 'package:flutter/material.dart';
import 'frontend/pages/create_trip_page.dart';
import 'frontend/pages/home_page.dart';
import 'frontend/pages/main_chat_page.dart';
import 'frontend/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color:Colors.white70 )),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
      HomePage(),
      // home: MainChatPage(tripId: '67ec1edd7af705f2c2b8d5ed', defaultUserId: '67ec1edc7af705f2c2b8d5eb'),
    );
  }
}
