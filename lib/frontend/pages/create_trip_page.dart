import 'package:flutter/material.dart';
import 'package:expances_management_app/frontend/wedgets.dart';
import '../../backend/api_services.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {

  final TextEditingController _groupName = TextEditingController();
  final TextEditingController _createByName = TextEditingController();
  final TextEditingController _createByEmail = TextEditingController();
  final TextEditingController _newUserName = TextEditingController();
  final TextEditingController _newUserEmail = TextEditingController();

  List<Map<String,dynamic>> _users = [];
  List<String> _selectedMembers = [];

  bool _isAddingUser = false;

  late ApiService apiService;

  Future<void> getUsersFromApi() async{
    List<Map<String, dynamic>> fetchedUsers = await apiService.getUsers();
    setState(() {
      _users = fetchedUsers;
    });
    print(_users);
  }

  Future<void> createTripGroup() async{
    if(_groupName.text.isNotEmpty && _createByEmail.text.isNotEmpty && _selectedMembers.isNotEmpty){
      final selectedId = await apiService.addUser(_createByName.text, _createByEmail.text);
      _selectedMembers.add(selectedId??'none');
      await apiService.createTrip(_groupName.text, selectedId!, _selectedMembers);
      showScaffoldMessenger('Group Created Successfully',Colors.green);
    }else{
      if(_groupName.text.isEmpty){
        showScaffoldMessenger('Enter your group name',Colors.red);
      }else if(_createByEmail.text.isEmpty){
        showScaffoldMessenger('Enter your Email',Colors.red);
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
    getUsersFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Trip'),backgroundColor: Colors.blue,),
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
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  onPressed: () {
                    createTripGroup();
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

  Widget _tripDetailsCard(){
    return Card(
      elevation: 0,
      color: Color(0xc5a0b0ee),
      shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)),borderSide: BorderSide.none),
      child: Column(
        children: [
          //trip details card details
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                  child: Icon(
                    Icons.explore,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12,),
                Text('Trip Details',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user name
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Name : ',style: TextStyle(fontSize: 15),),
                ),
                TextFormField(
                  controller: _createByName,
                  decoration: buildInputDecoration('Enter your name',Icons.person),
                ),

                //user email
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Email : ',style: TextStyle(fontSize: 15),),
                ),
                TextFormField(
                  controller: _createByEmail,
                  decoration: buildInputDecoration('Enter your Email',Icons.email),
                ),

                //trip name
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Trip Name:',style: TextStyle(fontSize: 15),),
                ),
                TextFormField(
                  controller: _groupName,
                  decoration: buildInputDecoration('Enter your trip name',Icons.travel_explore),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _tripMembersCard(){
    return Card(
      elevation: 0,
      color: Color(0xc5a4b3ee),
      shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)),borderSide: BorderSide.none),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //trip members card details
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //for icon and text
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Icon(
                        Icons.group_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Text('Trip Members',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
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
                    icon: _isAddingUser?Icon(Icons.close,color: Colors.black,):Icon(Icons.person_add,color: Colors.black,),
                    label: Text(_isAddingUser?'Cancel':'Add',style: TextStyle(color:Colors.black),),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Colors.lightBlueAccent.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //add new user part
          AnimatedCrossFade(
            firstChild: SizedBox(height: 0,),
            secondChild: _tripMemberCardAddUser(),
            crossFadeState: _isAddingUser? CrossFadeState.showSecond:CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300)
          ),

          //list of members
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Members',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Color(0xa3a0b0ee),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              user['name']![0].toUpperCase(),
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(user['name'],style: TextStyle(fontWeight: FontWeight.w600),),
                          subtitle: Text(user['email']),
                          trailing: Checkbox(
                            value: _selectedMembers.contains(user['_id']),
                            onChanged: (value) {
                              if(value == true){
                                setState(() {
                                  _selectedMembers.add(user['_id']);
                                });
                              }else{
                                setState(() {
                                  _selectedMembers.remove(user['_id']);
                                });
                              }
                            },
                            activeColor: Colors.blue,
                            checkColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.blue.withOpacity(0.3),
                        indent: 16,
                        endIndent: 16,
                      ),
                    ),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _tripMemberCardAddUser(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color(0xbd5483ec)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //user name
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Name : ',style: TextStyle(fontSize: 15),),
            ),
            TextFormField(
              controller: _newUserName,
              decoration: buildInputDecoration('Enter your name',Icons.person),
            ),
            SizedBox(height: 3,),
            //user email
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Email : ',style: TextStyle(fontSize: 15),),
            ),
            TextFormField(
              controller: _newUserEmail,
              decoration: buildInputDecoration('Enter your Email',Icons.email),
            ),
            SizedBox(height: 30,),

            //new user add button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    if(_newUserEmail.text.isNotEmpty && _newUserName.text.isNotEmpty){
                      await apiService.addUser(_newUserName.text, _newUserEmail.text);
                      _newUserEmail.clear();
                      _newUserName.clear();
                      setState(() {
                        _isAddingUser = false;
                      });
                      getUsersFromApi();
                    }
                    else{
                      if(_newUserEmail.text.isEmpty){
                        showScaffoldMessenger('Enter your name', Colors.red);
                      }else{
                        showScaffoldMessenger('Enter your Email', Colors.red);
                      }
                    }
                  },
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

