import 'package:excel_demo/constant/constants.dart';
import 'package:excel_demo/screens/g1_page.dart';
import 'package:excel_demo/screens/sg_stocks.dart';
import 'package:flutter/material.dart';

class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SgStocks())), child: Text('SgStocks')),
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => G1Panel())), child: Text('G1Panel')),
          Center(
            child: ElevatedButton(
              onPressed: () => authController.signOut(),
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
