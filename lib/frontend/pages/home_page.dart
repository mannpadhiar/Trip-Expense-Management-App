import 'package:expances_management_app/backend/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:expances_management_app/backend/local_storage.dart';
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

  // List<Map<String, dynamic>> tripInfoFromSql = [];
  late List<Map<String,dynamic>> _resentTrips = [];


  late ApiService api;
  late SqlDatabase sqlDatabase;

  Future<void> initTripSqlDatabase() async{
    await sqlDatabase.initDatabaseTrip();
    await getTripFromSqlDatabase();
  }

  Future<void> getTripFromSqlDatabase()async{
    List<Map<String, dynamic>> fetchedUsers = await sqlDatabase.fetchInfoFromTrip();
    setState(() {
      _resentTrips = fetchedUsers;
    });
    print('-+-+-+-+-+-+++-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+$_resentTrips');
  }

  Future<void> createSQLResentTrip(String userId,String tripId,String tripName) async{
    if(!_resentTrips.any((element) => (element['userId'] == userId && element['tripId'] == tripId))){
      await sqlDatabase.addDataTripSqlDatabase({
        'userId' : userId,
        'tripId' : tripId,
        'tripName' : tripName
      });
    }
  }


  @override
  void initState() {
    super.initState();
    api = ApiService();
    sqlDatabase = SqlDatabase();
    initSqlDatabase();
    initTripSqlDatabase();
  }

  // Future<void> fetchTripInfo() async {
  //   List<Map<String, dynamic>> info = await sqlDatabase.fetchInfo();
  //   setState(() {
  //     tripInfoFromSql = info;
  //   });
  // }

  Future<void> initSqlDatabase() async {
    await sqlDatabase.initDatabase();
    // await fetchTripInfo();
    // await sqlDatabase.deleteTripInfo(1);
    // await sqlDatabase.deleteTripInfo(3);
    // await sqlDatabase.addTripInfo({
    //   "tripName" :  'Goa',
    //   "tripId" : '67ec1edd7af705f2c2b8d5ed',
    //   "userName" : 'Meet',
    //   "userEmail" : 'meet@gmail.com',
    //   'userId' : '67ec1edc7af705f2c2b8d5eb',
    // });
  }

  //seekBar
  void showScaffoldMessenger(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                //header
                Text(
                  'Expense Manager',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Manage your group expenses effortlessly',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 40),
                //upper buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Create Trip Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateTripPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CupertinoColors.activeBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 22, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'Create Trip',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        "Trip ID",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: TextFormField(
                                        controller: _tripId,
                                        decoration: InputDecoration(
                                          hintText: "Enter Trip ID",
                                          prefixIcon: Icon(
                                            Icons.tag,
                                            color: CupertinoColors.link,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide(
                                              color: CupertinoColors.link,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.0,
                                          ),
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
                                        onPressed: () async {
                                          if (_tripId.text.isNotEmpty &&
                                              _name.text.isNotEmpty &&
                                              _email.text.isNotEmpty) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Center(
                                                    child:
                                                        LoadingAnimationWidget.fourRotatingDots(
                                                          color:
                                                              CupertinoColors
                                                                  .link,
                                                          size: 24,
                                                        ),
                                                  ),
                                            );

                                            Map<String, dynamic> tripInfo =
                                                await api.getTripInfo(
                                                  _tripId.text,
                                                );
                                            var userMemberId =
                                                tripInfo['members']
                                                    .firstWhere(
                                                      (member) =>
                                                          member['name']
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              _name.text
                                                                  .toLowerCase() &&
                                                          member['email']
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              _email.text
                                                                  .toLowerCase(),
                                                      orElse: () => null,
                                                    )['_id']
                                                    .toString();

                                            if (userMemberId != null) {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => MainChatPage(
                                                        tripId: _tripId.text,
                                                        defaultUserId:
                                                            userMemberId,
                                                      ),
                                                ),
                                              );

                                              //for adding in resent trip
                                              createSQLResentTrip(userMemberId,_tripId.text,tripInfo['name']);
                                            } else {
                                              userId = await api.addUser(
                                                _name.text,
                                                _email.text,
                                              );
                                              await api.addMemberToTrip(
                                                _tripId.text,
                                                userId!,
                                              );

                                              //for adding in resent trip
                                              await createSQLResentTrip(userId!,_tripId.text,tripInfo['name']);

                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => MainChatPage(
                                                        tripId: _tripId.text,
                                                        defaultUserId: userId!,
                                                      ),
                                                ),
                                              );
                                            }


                                          } else {
                                            showScaffoldMessenger(
                                              'Enter your Trip Id',
                                              Colors.red,
                                            );
                                            if (_tripId.text.isEmpty) {
                                              showScaffoldMessenger(
                                                'Enter your Trip Id',
                                                Colors.red,
                                              );
                                            } else if (_name.text.isEmpty) {
                                              showScaffoldMessenger(
                                                'Enter your Name',
                                                Colors.red,
                                              );
                                            } else {
                                              showScaffoldMessenger(
                                                'Enter your Email',
                                                Colors.red,
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              CupertinoColors.activeGreen,
                                          minimumSize: Size(
                                            double.infinity,
                                            56,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Join Trip',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.travel_explore,
                              size: 22,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            const Text(
                              'Join Trip',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 28,
                          color: Colors.deepPurpleAccent,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Resent Trips',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _resentTrips.isEmpty
                        ? Center(child: Text('No recent Trip'))
                        :ListView.builder(
                      shrinkWrap: true,
                      itemCount: _resentTrips.length,
                      itemBuilder: (context, index) {
                        return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainChatPage(tripId: _resentTrips[index]['tripId'], defaultUserId: _resentTrips[index]['userId']),));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //name and members
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _resentTrips[index]['tripName'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          ///members
                                          Row(
                                            children: [
                                              Icon(Icons.group,size: 18,color: Colors.black54),
                                              SizedBox(width: 3,),
                                              Text('4 members',style: TextStyle(color: Colors.black54),),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.currency_rupee,size: 16,color: Colors.green,),
                                          Text('20000',style: TextStyle(color: Colors.green,fontSize: 14,fontWeight: FontWeight.w600),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tripDetailsCard() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
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
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
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
