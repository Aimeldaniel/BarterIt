import 'dart:async';
import 'dart:convert';

import 'package:barterlt/views/screens/loginscreen.dart';
import 'package:flutter/material.dart';
//import 'package:barterlt/views/screens/ProfileTabScreen.dart';
import 'package:barterlt/views/screens/ChatTabScreen.dart';
import 'package:barterlt/views/screens/ItemListingTabScreen.dart';
import 'package:barterlt/views/screens/NewsTabScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/user.dart';
import '../../myconfig.dart';
//import 'buyertabscreen.dart';
//import 'newtabscreen.dart';

//for buyer screen

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Buyer";

  @override
  void initState() {
    super.initState();
    print("Mainscreen");
    getData();
    tabchildren = [
      ItemListingTabScreen(),
      ChatTabScreen(),
      NewsTabScreen()
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barterlt"),
      leading: IconButton(onPressed: (){}, icon: Icon(Icons.logout)),
      actions: [IconButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }, icon: Icon(Icons.person))],),
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_shopping_cart,
                ),
                label: "ItemListing"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message_rounded,
                ),
                label: "Chatting"),     
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.newspaper,
                ),
                label: "News")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "ItemListing";
      }
      if (_currentIndex == 1) {
        maintitle = "Chatting";
      }
      if (_currentIndex == 2) {
        maintitle = "News";
      }
    });
  }
  Future<void> getData() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = (prefs.getString('email')) ?? '';
      String password = (prefs.getString('pass')) ?? '';
      onLogin(email, password);

  }

  void onLogin(String email1, String password1) {
    String email = email1;
    String pass = password1;
    print(email);
    print(pass);
    try {
      http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/login_user.php"),
          body: {
            "email": email,
            "password": pass,
          }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            print(user.name);
            print(user.email);
            ScaffoldMessenger.of(context)
                .showSnackBar( SnackBar(content: Text("Welcome back ${user.name != null ? user.name : ""}")));
            
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Failed")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        // Time has run out, do what you wanted to do.
      });
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }  
}