import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expances_management_app/frontend/wedgets.dart';
import '../../backend/api_services.dart';
import '../../backend/local_storage.dart';
import 'main_chat_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {

  Color primaryColor = Color(0xff041C32);
  Color secondaryColor = Color(0xff4DA1A9);

  final TextEditingController _groupName = TextEditingController();
  final TextEditingController _createByName = TextEditingController();
  final TextEditingController _newUserName = TextEditingController();

  List<Map<String,dynamic>> _users = [];
  List<Map<String,dynamic>> _resentTrips = [];
  List<String> _selectedMembers = [];


  bool _isAddingUser = false;

  late ApiService apiService;
  late SqlDatabase sqlDatabase;

  String? tripIdSelected = '';

  Future<void> getUsersFromSqlDatabase()async{
    List<Map<String, dynamic>> fetchedUsers = await sqlDatabase.fetchInfoFromUser();
    setState(() {
      _users = fetchedUsers;
    });
  }


  Future<void> initUserSqlDatabase() async{
    await sqlDatabase.initDatabaseUser();
    await getUsersFromSqlDatabase();
  }

  //for add trip in resent trip
  Future<void> initTripSqlDatabase() async{
    await sqlDatabase.initDatabaseTrip();
    await getTripFromSqlDatabase();
  }

  Future<void> getTripFromSqlDatabase()async{
    List<Map<String, dynamic>> fetchedUsers = await sqlDatabase.fetchInfoFromTrip();
    setState(() {
      _resentTrips = fetchedUsers;
    });
  }

  Future<void> createSQLResentTrip(String userId,String tripId,String tripName) async{
    if(!_resentTrips.any((element) => (element['userId'] == userId && element['tripId'] == tripId))){
      await sqlDatabase.addDataTripSqlDatabase({
        'userId' : userId,
        'tripId' : tripId,
        'tripName' : tripName,
      });
    }
  }
  //

  Future<void> createTripGroup() async{
    if(_groupName.text.isNotEmpty && _selectedMembers.isNotEmpty){
      showDialog(
        context: context,
        builder: (context) => Center(child: LoadingAnimationWidget.fourRotatingDots(
          color: CupertinoColors.link,
          size: 24,
        ),),
      );

      final selectedId = await apiService.addUser(_createByName.text);
      _selectedMembers.add(selectedId??'none');
      tripIdSelected = await apiService.createTrip(_groupName.text, selectedId!, _selectedMembers);

      await createSQLResentTrip(selectedId,tripIdSelected!,_groupName.text);

      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainChatPage(tripId: tripIdSelected!,defaultUserId: selectedId,),));
      showScaffoldMessenger('Group Created Successfully',Colors.green);
    }else{
      if(_groupName.text.isEmpty){
        showScaffoldMessenger('Enter your group name',Colors.red);
      }else{
        showScaffoldMessenger('Select atleast one member',Colors.red);
      }
    }
  }


  void showScaffoldMessenger(String message,Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService = ApiService();
    sqlDatabase = SqlDatabase();
    initUserSqlDatabase();
    initTripSqlDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ecdd),
      appBar: AppBar(title: Text('Create Trip',style: TextStyle(color: Colors.white),),backgroundColor: primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _tripDetailsCard(),
                SizedBox(height: 20,),
                _tripMembersCard(),
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  onPressed: () async{
                    await createTripGroup();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,size: 22,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Create Trip Group',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 17),),
                    ],
                  ),
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
      elevation: 0,
      color: Color(0xffb1d7d9),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      child: Column(
        children: [
          // trip details card header
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                  child: Icon(
                    Icons.explore,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Trip Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // form content
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user name
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Name : ',
                    style: TextStyle(fontSize: 15, color: Color(0xff041C32),fontWeight: FontWeight.w600),
                  ),
                ),
                TextFormField(
                  controller: _createByName,
                  decoration: buildInputDecoration(
                    'Enter your name',
                    Icons.person,
                  ),
                ),

                // trip name
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Trip Name:',
                    style: TextStyle(fontSize: 15, color: Color(0xff041C32),fontWeight: FontWeight.w600),
                  ),
                ),
                TextFormField(
                  controller: _groupName,
                  decoration: buildInputDecoration(
                    'Enter your trip name',
                    Icons.travel_explore,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripMembersCard() {
    return Card(
      elevation: 0,
      color: Color(0xffb1d7d9),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Icon(
                        Icons.group_rounded,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Trip Members',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  switchInCurve: Curves.easeInQuad,
                  switchOutCurve: Curves.linearToEaseOut,
                  child: TextButton.icon(
                    key: ValueKey<bool>(_isAddingUser),
                    onPressed: () {
                      setState(() {
                        _isAddingUser = !_isAddingUser;
                      });
                    },
                    icon: _isAddingUser
                        ? Icon(Icons.close, color: primaryColor)
                        : Icon(Icons.person_add, color: primaryColor),
                    label: Text(
                      _isAddingUser ? 'Cancel' : 'Add',
                      style: TextStyle(color: primaryColor),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Color(0xff4DA1A9).withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Add new user section
          AnimatedCrossFade(
            firstChild: SizedBox(height: 0),
            secondChild: _tripMemberCardAddUser(),
            crossFadeState:
            _isAddingUser ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),

          // User list section
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Members',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Color(0xffd2edf0),
                  ),
                  child:_users.isEmpty ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Enter the user first')),
                  ) :  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child:ListView.separated(
                      shrinkWrap: true,
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xff4DA1A9),
                            child: Text(
                              user['userName']![0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            user['userName'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff041C32),
                            ),
                          ),
                          trailing: Checkbox(
                            value: _selectedMembers.contains(user['userId']),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedMembers.add(user['userId']);
                                } else {
                                  _selectedMembers.remove(user['userId']);
                                }
                              });
                              setState(() {});
                            },
                            activeColor: Color(0xff4DA1A9),
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Color(0xff4DA1A9).withOpacity(0.3),
                        indent: 16,
                        endIndent: 16,
                      ),
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

  Widget _tripMemberCardAddUser() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color(0xffc7e9ec),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // user name
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Name : ',
                style: TextStyle(fontSize: 15, color: primaryColor,fontWeight: FontWeight.w600),
              ),
            ),
            TextFormField(
              controller: _newUserName,
              decoration: buildInputDecoration('Enter your name', Icons.person),
            ),
            SizedBox(height: 30),

            // button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: CupertinoColors.link,
                          size: 24,
                        ),
                      ),
                    );
                    if (_newUserName.text.isNotEmpty) {
                      final id = await apiService.addUser(_newUserName.text);
                      await sqlDatabase.addDataUserSqlDatabase({
                        'userId': id,
                        'userName': _newUserName.text,
                      });
                      _newUserName.clear();
                      setState(() {
                        _isAddingUser = false;
                      });
                      getUsersFromSqlDatabase();
                    } else {
                        showScaffoldMessenger('Enter your Name', Colors.red);
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4DA1A9),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Add User'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

