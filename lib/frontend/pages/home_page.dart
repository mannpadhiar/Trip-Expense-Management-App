import 'package:expances_management_app/backend/api_services.dart';
import 'package:expances_management_app/frontend/pages/qr_scanner_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../wedgets.dart';
import 'create_trip_page.dart';
import 'main_chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? userId = '';

  TextEditingController _tripId = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();

  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SafarShare',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: CupertinoColors.link,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Create Trip Section
              Text(
                'Make a trip',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTripPage(),));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CupertinoColors.activeBlue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Create Trip',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Join Trip Section
              Text(
                'Join a trip',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Handle bar for dragging
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 12),
                                  height: 5,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              // Header
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Join a Trip",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.link,
                                  ),
                                ),
                              ),
                              // Trip ID Input
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  "Trip ID",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: TextFormField(
                                  controller: _tripId,
                                  decoration: InputDecoration(
                                    hintText: "Enter Trip ID",
                                    prefixIcon: Icon(Icons.tag, color: CupertinoColors.link),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: CupertinoColors.link, width: 2),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              // Trip Details Section
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(16.0),
                                  child: _tripDetailsCard(),
                                ),
                              ),

                              // Join Button
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () async{
                                    if(_tripId.text.isNotEmpty && _name.text.isNotEmpty && _email.text.isNotEmpty){
                                      showDialog(
                                        context: context,
                                        builder:
                                          (context) =>Center(child: LoadingAnimationWidget.fourRotatingDots(
                                            color: CupertinoColors.link,
                                            size: 24,
                                          ),
                                        ),
                                      );
                                      userId = await api.addUser(_name.text, _email.text);
                                      await api.addMemberToTrip(_tripId.text, userId!);
                                      Navigator.of(context).pop();
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => MainChatPage(tripId: _tripId.text,defaultUserId: userId!,),));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CupertinoColors.activeGreen,
                                    minimumSize: Size(double.infinity, 56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Join Trip',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CupertinoColors.activeGreen,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Join Trip',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tripDetailsCard() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Card header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.explore,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Your Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                SizedBox(height: 16),

                // Email field
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),

                // Instructions
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your information will only be shared with trip members',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
