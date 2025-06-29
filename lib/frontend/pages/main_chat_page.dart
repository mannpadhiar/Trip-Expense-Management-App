// import 'dart:ffi';
import 'dart:convert';
import 'package:expances_management_app/backend/api_services.dart';
import 'package:expances_management_app/frontend/pages/home_page.dart';
import 'package:intl/intl.dart';
import '../expense_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class MainChatPage extends StatefulWidget {
  final String tripId;
  final String defaultUserId;
  const MainChatPage({super.key,required this.tripId,required this.defaultUserId});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage>
    with SingleTickerProviderStateMixin {
  //who is user come from previous page initialize in init state
  
  Color primaryColor = Color(0xff041C32);
  Color secondaryColor = Color(0xff4DA1A9);
  
  late String _userSelectFromButton;
  late String _userSelectFromButtonName;

  late TabController _tabController;
  late ApiService api;
  late ExpenseCalculator calculator;

  //from api
  late Map<String, dynamic> _tripInformation = {};
  late List<Map<String, dynamic>> _transactionsInformation = [];

  //for solve rebuilding the body in futureBuilder
  late Future<Map<String, dynamic>> futureTripInfo;
  late Future<List<Map<String, dynamic>>> futureTransactionInfo;

  TextEditingController _tripDescriptionController = TextEditingController();
  TextEditingController _tripAmountController = TextEditingController();

  List<Map<String, dynamic>> selectedPersons = [];

  Map<String,dynamic> settlementsInformation = {'settlements': []};

  double _totalSpent = 0;

  bool isUserFetched = false;

  String shortenObjectId(String objectIdHex) {
    final bytes = hexToBytes(objectIdHex);
    return base64UrlEncode(bytes); // URL-safe Base64
  }

  List<int> hexToBytes(String hex) {
    final result = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return result;
  }


  void setUserName(){
    _userSelectFromButtonName = _tripInformation['members'].firstWhere(
      (member) => member['_id'] == widget.defaultUserId,
      orElse: () => '!',
    )['name'];
    print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^$_userSelectFromButtonName');
  }

  Future<Map<String, dynamic>> fetchTripInfo() async {
    final info = await api.getTripInfo(widget.tripId);
    setState(() {
      _tripInformation = info;
    });
    if(!isUserFetched)setUserName();
    isUserFetched = true;

    //for select all person in selection of distribution
    selectedPersons = List<Map<String, dynamic>>.from(
      _tripInformation['members'],
    );

    return _tripInformation;
  }

  Future<List<Map<String, dynamic>>> fetchTransactionInfo() async {
    final info = await api.getTransactions(widget.tripId);
    setState(() {
      _transactionsInformation = info;
    });
    calcTotal();
    setCalculatedSettlements();
    return _transactionsInformation;
  }

  void calcTotal(){
    setState(() {
      _totalSpent = calculator.calcTotalSpent(_transactionsInformation);
    });
  }

  void setCalculatedSettlements(){
    setState(() {
      settlementsInformation = calculator.calculateSettlements(_transactionsInformation);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    api = ApiService();
    _userSelectFromButton = widget.defaultUserId;
    calculator = ExpenseCalculator();
    futureTripInfo = fetchTripInfo();
    futureTransactionInfo = fetchTransactionInfo();
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
      backgroundColor: Color(0xfff8f4ee),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Trip Expenses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([futureTripInfo, futureTransactionInfo]),
        builder: (context, snapshot) {
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;

          return Skeletonizer(
            enabled: isLoading,
            effect: ShimmerEffect(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            child: Column(
              children: [
                _headerOfPage(),
                _tabBarButtons(),
                _mainContent()
              ],
            ),
          );
        },
      ),

      endDrawer: SafeArea(
        child: Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with ID
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trip ID:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _tripInformation['_id'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),


                const Spacer(),

                // Leave button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout,color: Colors.white),
                    label: const Text(
                      'Leave Trip',
                      style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),)); // or push to another screen
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),

      // FutureBuilder(
      //   future: futureTripInfo,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text("Error: ${snapshot.error}"));
      //     } else if (snapshot.hasData) {
      //       return Column(
      //         children: [_headerOfPage(), _tabBarButtons(), _mainContent()],
      //       );
      //     }
      //     return Text('No Data Found!!!');
      //   },
      // ),
    );
  }

  Widget _headerOfPage() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //total spent side box
              Column(
                children: [
                  Text(
                    'Total Spent',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, size: 24, color: Colors.white),
                      Text(
                        _totalSpent.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Per Person',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, size: 24, color: Colors.white),
                      Text(
                        (_totalSpent/selectedPersons.length).ceilToDouble().toString(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBarButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: Colors.white),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        tabs: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet_outlined),
                SizedBox(width: 2),
                Text('Payments'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart_outline),
                SizedBox(width: 2),
                Text('Settle Up'),
              ],
            ),
          ),
        ],
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
      ),
    );
  }

  Widget _mainContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          //first tab bar view
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //message part
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child:_transactionsInformation.isEmpty ? _noMemberShow() : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            bool isRightSide =
                                _transactionsInformation[index]['paidBy']['_id'] ==
                                    _userSelectFromButton;
                            return Align(
                              alignment: isRightSide ? Alignment.centerRight : Alignment.centerLeft,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        borderRadius: isRightSide
                                            ? BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(30),
                                        )
                                            : BorderRadius.only(
                                          bottomRight: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(30),
                                        ),
                                        color: secondaryColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //amount part
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.currency_rupee,
                                                color: Colors.white,
                                                size: 26,
                                              ),
                                              Text(
                                                _transactionsInformation[index]['amount'].toString(),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),

                                          //description part
                                          Text(
                                            _transactionsInformation[index]['description'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4,),

                                          //distribution to part
                                          IntrinsicWidth(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text('To : ',style: TextStyle(fontWeight: FontWeight.w600),),
                                                ),
                                                for(int i = 0; i < _transactionsInformation[index]['distributedTo'].length;i++)
                                                  Align(
                                                    widthFactor: .6,
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor: secondaryColor,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.white,
                                                        radius: 10,
                                                        child: Text(_transactionsInformation[index]['distributedTo'][i]['userId']['name'][0].toString().toUpperCase(),style: TextStyle(fontSize: 10),),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 4,),

                                          //date-time
                                          Text(DateFormat('EEE,dd MMM').format(DateTime.parse(_transactionsInformation[index]['createdDate'])),style: TextStyle(fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //circular avatar positioned differently based on isRightSide
                                  Positioned(
                                    right: isRightSide ? 0 : null,
                                    left: isRightSide ? null : 0,
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xff041C32),
                                      radius: 20,
                                      child: Text(
                                        _transactionsInformation[index]['paidBy']['name'][0].toUpperCase(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: _transactionsInformation.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _footerPart(),
            ],
          ),
          //second tab bsr view
          _secondTabBarView(),
        ],
      ),
    );
  }

  Widget _footerPart() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //top part of footer
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tripDescriptionController,
                    cursorColor: Colors.white,
                    cursorRadius: Radius.circular(20),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter Your Description...',
                      hintStyle: TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: primaryColor,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder:
                          (context) =>
                          Center(child: LoadingAnimationWidget.fourRotatingDots(
                            color: primaryColor,
                            size: 24,
                          ),),
                    );

                    //for seekBar in bottom
                    if (_tripAmountController.text.isNotEmpty && int.parse(_tripAmountController.text) != 0 &&
                        _tripAmountController.text.isNotEmpty && selectedPersons.isNotEmpty) {

                      int personCount = selectedPersons.length;

                      List<Map<String, dynamic>> distributedTo = selectedPersons.map((personId) {
                        return {
                          "userId": personId,
                          "amount": double.parse(_tripAmountController.text) / personCount,
                        };
                      }).toList();

                      await api.addTransaction(
                        _tripInformation['_id'],
                        _userSelectFromButton,
                        double.parse(_tripAmountController.text),
                        distributedTo,
                        _tripDescriptionController.text,
                      );
                      await fetchTransactionInfo();
                      _tripAmountController.clear();
                      _tripDescriptionController.clear();
                    }
                    else {
                      if(_tripAmountController.text.isEmpty){
                        showScaffoldMessenger(
                          'Enter your Amount',
                          Colors.red,
                        );
                      }else if(int.parse(_tripAmountController.text) == 0){
                        showScaffoldMessenger(
                          'Enter your zero',
                          Colors.red,
                        );
                      }else if(_tripDescriptionController.text.isEmpty){
                        showScaffoldMessenger(
                          'Enter your Description',
                          Colors.red,
                        );
                      }else{
                        showScaffoldMessenger(
                          'Select minimum one person',
                          Colors.red,
                        );
                      }
                    }
                    Navigator.of(context).pop();
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.telegram, color: Colors.black, size: 41),
                  ),
                ),
              ],
            ),

            //bottom part of footer
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //select user
                PopupMenuButton(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                  padding: EdgeInsets.all(0),
                  initialValue: _userSelectFromButton,
                  icon: CircleAvatar(
                    radius: 23,
                    backgroundColor: Color(0xffF2EFE7),
                    child: FutureBuilder(
                      future: futureTripInfo,
                      builder: (context, snapshot) {
                         if(snapshot.connectionState == ConnectionState.waiting){
                           return CircularProgressIndicator(color: Colors.white,);
                         }
                         if(snapshot.hasError){
                           return Text('There is an error');
                         }
                         if(snapshot.hasData){
                           return Text(_userSelectFromButtonName[0].toUpperCase(),style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),);
                         }
                         return Text('!!');
                      },
                    ),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _userSelectFromButton = value;
                    });
                    print('User selected : $_userSelectFromButton');
                  },
                  itemBuilder: (BuildContext context) =>
                      List.from(_tripInformation['members']).map(
                          (item) => PopupMenuItem<String>(
                        value: item['_id'],
                        onTap: () {
                          setState(() {
                            _userSelectFromButtonName = item['name'];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xd84da1a9),
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 20,
                                child: Text(
                                  item['name'][0].toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                item['name'],
                                style: TextStyle(fontSize: 14,color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).toList(),
                ),

                // InkWell(
                //   child: CircleAvatar(
                //     backgroundColor: Colors.black87,
                //     child: Icon(Icons.person, color: Colors.white,),
                //   ),
                //   onTap: () {
                //
                //   },
                // ),

                //amount section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _tripAmountController,
                      cursorColor: Colors.white,
                      cursorRadius: Radius.circular(20),
                      cursorHeight: 20,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Amount...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        filled: true,
                        fillColor: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Split expense button
                InkWell(
                  onTap: () {
                    _showPersonSelectionDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, color: Colors.white, size: 18),
                        SizedBox(width: 4),

                        FutureBuilder(
                          future: futureTripInfo,
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Container(
                                height:20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white),
                              );
                            }
                            if(snapshot.hasError){
                              return Text('There is an error');
                            }
                            if(snapshot.hasData){
                              return Text(
                                _tripInformation['members'].length == selectedPersons.length ? "All" : selectedPersons.length.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              );
                            }
                            return Text('!!');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondTabBarView(){
    return Column(
      children: [
        Expanded(
          child: settlementsInformation['settlements'].isEmpty ? _noMemberShow() :ListView.builder(
            itemCount: settlementsInformation['settlements'].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      border: Border(
                        left: BorderSide(color: primaryColor,width: 8),
                      ),
                      color: Color(0xe44da1a9),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //name information
                      Row(
                        children: [
                          Text(settlementsInformation['settlements'][index]['from'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.arrow_right_alt,color: Colors.white,size: 30,),
                          ),
                          Text(settlementsInformation['settlements'][index]['to'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      //amount
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.currency_rupee,size: 15),
                            Text(settlementsInformation['settlements'][index]['amount'].toString(),style: TextStyle(fontWeight: FontWeight.w800),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _noMemberShow(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_rupee,size: 80,color: Colors.black12,),
            Text("Make first Transaction",style: TextStyle(color: Colors.black12,fontSize: 14,fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    );
  }

  //person selection dialog
  void _showPersonSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Split with',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  const Divider(thickness: 1),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _tripInformation['members'].length,
                    itemBuilder: (context, index) {
                      final person = _tripInformation['members'][index];
                      final isSelected = selectedPersons.contains(person);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: CheckboxListTile(
                          activeColor: primaryColor,
                          dense: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(person['name']),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedPersons.add(person);
                              } else {
                                selectedPersons.remove(person);
                              }
                            });
                            print(selectedPersons);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('OK',style: TextStyle(color: primaryColor),),
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}