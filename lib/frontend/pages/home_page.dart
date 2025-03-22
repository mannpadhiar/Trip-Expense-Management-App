import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SafarShare'),),
      body: SafeArea(
        child: Column(
          children: [

            //button for creating a group
            ElevatedButton(
              onPressed: () {
                // Navigator.push(context, route);
              },
              child: Text('Create Trip'),
            ),

            //button for joining a group
            ElevatedButton(onPressed: () {

            }, child: Text('Create Trip'))
          ],
        ),
      ),
    );
  }
}
