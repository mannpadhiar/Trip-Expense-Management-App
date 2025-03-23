import 'package:expances_management_app/backend/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late ApiService api ;

  //from api
  late Map<String,dynamic> _tripInformation;

  TextEditingController _tripDescriptionController = TextEditingController();
  TextEditingController _tripAmountController = TextEditingController();

  Future<void> fetchTripInfo() async{
    final info = await api.getTripInfo('67dfdefddf5f89e5bee84bfc');
    setState(() {
      _tripInformation = info;
    });
    print(_tripInformation);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    api = ApiService();
    fetchTripInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: CupertinoColors.link,
        title: Text(
          'Trip Expenses',
          style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          _headerOfPage(),
          _tabBarButtons(),
          _mainContent(),
        ],
      ),
    );
  }

  Widget _headerOfPage(){
    return Container(
      decoration: BoxDecoration(
          color:CupertinoColors.link,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //total spent side box
            Column(
              children: [
                Text('Total Spent',style: TextStyle(fontSize: 15,color: Colors.white70,fontWeight: FontWeight.w500),),
                Row(
                  children: [
                    Icon(Icons.currency_rupee,size: 24,color: Colors.white,),
                    Text('00.00',style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),)
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text('Per Person',style: TextStyle(fontSize: 15,color: Colors.white70,fontWeight: FontWeight.w500),),
                Row(
                  children: [
                    Icon(Icons.currency_rupee,size: 24,color: Colors.white,),
                    Text('00.00',style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _tabBarButtons(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
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
                SizedBox(width: 2,),
                Text('Payments')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart_outline),
                SizedBox(width: 2,),
                Text('Settle Up')
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

  Widget _mainContent(){
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              //message part
              Expanded(
                child: Column(
                  children: [],
                ),
              ),
              _footerPart(),
            ],
          ),
          Center(child: Text('Settle Up is hear')),
        ]
      ),
    );
  }

  Widget _footerPart() {
    List<String> selectedPersons = ['John','Alex'];
    List<String> allPersons = ['John', 'Mary', 'Alex', 'Sara', 'Mike'];

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.link,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //top part of footer
            TextFormField(
              controller: _tripDescriptionController,
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(20),
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  hintText: 'Enter Your Description...',
                  hintTextDirection: TextDirection.ltr,
                  hintStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: CupertinoColors.link,
                  border: OutlineInputBorder(borderSide: BorderSide.none)
              ),
            ),

            //bottom part of footer
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //select user
                InkWell(
                  child: CircleAvatar(
                    backgroundColor: Colors.black87,
                    child: Icon(Icons.person, color: Colors.white,),
                  ),
                  onTap: () {
                    
                  },
                ),

                //amount section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _tripAmountController,
                      cursorColor: Colors.white,
                      cursorRadius: Radius.circular(20),
                      cursorHeight: 20,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Amount...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.white54),
                        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(40))),
                        filled: true,
                        fillColor: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Split expense button
                InkWell(
                  onTap: () {
                    _showPersonSelectionDialog(context,allPersons,['John']);
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
  void _showPersonSelectionDialog(BuildContext context, List<String> allPersons, List<String> selectedPersons) {
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
                      title: Text(person),
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedPersons.add(person);
                        } else {
                          selectedPersons.remove(person);
                        }
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
                    Navigator.of(context).pop(selectedPersons);
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
}
