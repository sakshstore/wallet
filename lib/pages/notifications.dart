import 'package:flutter/material.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/pages/welcome.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:jada/util/app_url.dart';
import 'package:jada/util/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:jada/providers/auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:jada/providers/auth.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String loading = "";
  List Notifications=[];

  Future<String> getLoginHistory() async {
    String link = "https://wapi.alphakoin.io/api/wallet/system_notification";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(22);
    String access_token;
    access_token = prefs.getString('access_token')!;

    var res = await http.get(  Uri.parse(link), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access_token'
    });

    print(res.body);
    print(32);

    //   var data = json.decode(res.body);

    return res.body;
  }

  @override
  void initState() {
    super.initState();

    getLoginHistory().then((val) {
      setState(() {});

      var data = json.decode(val);

      Notifications = data;

      print(Notifications);
      print("success");
    }).catchError((error, stackTrace) {
      print(57);
      print("outer: $error");
    });

    print(5353);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

    AuthProvider auth = Provider.of<AuthProvider>(context);

    void _onItemTapped(int index) {
      setState(() {
        if (index == 0)
          Navigator.pushReplacementNamed(context, '/dashboard');
        else if (index == 1)
          Navigator.pushReplacementNamed(context, '/sendfund');
        else if (index == 2)
          Navigator.pushReplacementNamed(context, '/transactions');
        else
          Navigator.pushReplacementNamed(context, '/settings');
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          elevation: 0.1,
        ),
        body: new ListView.builder(
          itemCount: Notifications == null ? 0 : Notifications.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: Icon(Icons.album, size: 50),
                    title: Text(Notifications[index]["message"]),
                    subtitle: Text(Notifications[index]["created_at"]),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 3, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.send),
              label: 'Send Fund',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.view_list),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.view_list),
              label: 'Login History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            )
          ],
          backgroundColor: Colors.red,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,

          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
