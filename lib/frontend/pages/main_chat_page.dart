import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: CupertinoColors.link,
        title: Text(
          'Trip Expenses',
          style: TextStyle(color: Colors.white,fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          _headerOfPage(),
          _tabBarButtons(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: Text('payments are hear')),
                Center(child: Text('Settle Up is hear')),
              ]
            ),
          )
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
}
