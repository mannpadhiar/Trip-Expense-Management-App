// import 'dart:ffi';
import 'package:expances_management_app/backend/api_services.dart';
import '../expense_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage>
    with SingleTickerProviderStateMixin {
  //who is user come from previous page
  String _userSelectFromButton = '67dfdefcdf5f89e5bee84bfa';
  String _tripId = '67dfdefddf5f89e5bee84bfc';

  late TabController _tabController;
  late ApiService api;
  late ExpenseCalculator calculator;

  //from api
  late Map<String, dynamic> _tripInformation;
  late List<Map<String, dynamic>> _transactionsInformation;

  //for solve rebuilding the body in futureBuilder
  late Future<Map<String, dynamic>> futureTripInfo;
  late Future<List<Map<String, dynamic>>> futureTransactionInfo;

  TextEditingController _tripDescriptionController = TextEditingController();
  TextEditingController _tripAmountController = TextEditingController();

  List<Map<String, dynamic>> selectedPersons = [];

  double _totalSpent = 0;

  Future<Map<String, dynamic>> fetchTripInfo() async {
    final info = await api.getTripInfo(_tripId);
    setState(() {
      _tripInformation = info;
    });
    print(_tripInformation);

    //for select all person in selection of distribution
    selectedPersons = List<Map<String, dynamic>>.from(
      _tripInformation['members'],
    );

    return _tripInformation;
  }

  Future<List<Map<String, dynamic>>> fetchTransactionInfo() async {
    final info = await api.getTransactions(_tripId);
    setState(() {
      _transactionsInformation = info;
    });
    calcTotal();
    return _transactionsInformation;
  }

  void calcTotal(){
    setState(() {
      _totalSpent = calculator.calcTotalSpent(_transactionsInformation);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    api = ApiService();
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: CupertinoColors.link,
        title: Text(
          'Trip Expenses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
        future: futureTripInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return Column(
              children: [_headerOfPage(), _tabBarButtons(), _mainContent()],
            );
          }
          return Text('No Data Found!!!');
        },
      ),
    );
  }

  Widget _headerOfPage() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.link,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
                      '00.00',
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
          color: CupertinoColors.link,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //message part
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
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
                                      padding: EdgeInsets.all(25),
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
                                        color: Colors.blueAccent,
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

                                          //description part
                                          // Row(
                                          //   children: [
                                          //     Stack(
                                          //       children: [
                                          //         ListView.builder(
                                          //           itemBuilder: (context, tempIndex) {
                                          //             return CircleAvatar(
                                          //               child: Text(_transactionsInformation[index]['distributedTo'][tempIndex][]),
                                          //             );
                                          //           },
                                          //           itemCount: _transactionsInformation[index]['distributedTo']['distributedTo'],
                                          //         )
                                          //       ],
                                          //     )
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                  //circular avatar positioned differently based on isRightSide
                                  Positioned(
                                    right: isRightSide ? 0 : null,
                                    left: isRightSide ? null : 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
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
          Center(child: Text('Settle Up is hear')),
        ],
      ),
    );
  }

  Widget _footerPart() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.link,
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
                      hintTextDirection: TextDirection.ltr,
                      hintStyle: TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: CupertinoColors.link,
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
                              Center(child: CircularProgressIndicator()),
                    );

                    //for seekBar in bottom
                    if (_tripAmountController.text.isNotEmpty &&
                        _tripAmountController.text.isNotEmpty) {
                      await api.addTransaction(
                        _tripInformation['_id'],
                        _userSelectFromButton,
                        double.parse(_tripAmountController.text),
                        selectedPersons,
                        _tripDescriptionController.text,
                      );
                      await fetchTransactionInfo();
                    } else {
                      showScaffoldMessenger(
                        'Enter your full massage',
                        Colors.red,
                      );
                    }
                    _tripAmountController.clear();
                    _tripDescriptionController.clear();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.telegram, color: Colors.black, size: 41),
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
                    backgroundColor: Colors.black87,
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                  onSelected: (value) {
                    setState(() {
                      _userSelectFromButton = value;
                    });
                    print('User selected : $_userSelectFromButton');
                  },
                  itemBuilder:
                      (BuildContext context) =>
                          List.from(_tripInformation['members'])
                              .map(
                                (item) => PopupMenuItem<String>(
                                  value: item['_id'],
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
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
                                          backgroundColor: Colors.blue[200],
                                          radius: 20,
                                          child: Text(
                                            item['name'][0].toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          item['name'],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
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
                          color: Colors.white54,
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
                        Text(
                          'Split',
                          style: TextStyle(color: Colors.white, fontSize: 14),
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

  //person selection dialog
  void _showPersonSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Split with'),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _tripInformation['members'].length,
                  itemBuilder: (context, index) {
                    final person = _tripInformation['members'][index];
                    final isSelected = selectedPersons.contains(person);
                    return CheckboxListTile(
                      title: Text(person['name']),
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedPersons.add(person);
                        } else {
                          selectedPersons.remove(person);
                        }
                        print(selectedPersons);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    print('--------------$selectedPersons');
                    Navigator.of(context).pop(selectedPersons);
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
