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

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String balance = "";
  String address = "";
  String last_login_ip = "";
  String last_login = "";

  // show last login
  // show balance

  // show deposit

  // show last 3 notifiction
  // total login failure since your  last login
  // your current IP address

  Future<String> getDashboard() async {
    String link = "https://wapi.alphakoin.io/api/v3/wallet/Dashboard";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(22);
    String access_token = prefs.getString('access_token')!;

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

    balance = "Loading....";

    getDashboard().then((val) {
      balance = val;
      print(49);
      setState(() {});

      var data = json.decode(val);

      balance = data['balance'];

      address = data['address'];

      last_login = "Last Login " + data['login_history']['created_at'];

      last_login_ip = " From the IP " + data['login_history']['ip'];

      print(51);
      print("success");
    }).catchError((error, stackTrace) {
      print(57);
      print("outer: $error");
    });

    print(5353);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    final img_logo = Image.asset('images/alphakoin.png');
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var s = SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(text: address, style: TextStyle(color: Colors.red)),
        ],
      ),
    );

    var welcome = Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text('Welcome '),
            subtitle: Text(user.email??''),
          ),
        ],
      ),
    );

    var lastlogin = Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text(last_login),
            subtitle: Text(last_login_ip),
          ),
        ],
      ),
    );

    var balanceCard = new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text("Balance in Alphakoin"),
            subtitle: Text(balance),
          ),
        ],
      ),
    );

    var addressCard = new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text("Request Alphakoin"),
            subtitle: s,
          ),
        ],
      ),
    );

    print(48);

    void _onItemTapped(int index) {
      setState(() {
        if (index == 0)
          Navigator.pushReplacementNamed(context, '/dashboard');
        else if (index == 1)
          Navigator.pushReplacementNamed(context, '/sendfund');
        else if (index == 2)
          Navigator.pushReplacementNamed(context, '/transactions');
        else if (index == 3)
          Navigator.pushReplacementNamed(context, '/loginhistory');
        else
          Navigator.pushReplacementNamed(context, '/changepassword');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Alphakoin Wallet"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          SizedBox(height: 15.0),
          img_logo,
          SizedBox(
            height: 100,
          ),
          welcome,
          SizedBox(
            height: 100,
          ),
          lastlogin,
          SizedBox(
            height: 100,
          ),
          balanceCard,
          SizedBox(
            height: 100,
          ),
          addressCard,
          SizedBox(height: 100),
          RaisedButton(
            onPressed: () {},
            child: Text("Logout"),
            color: Colors.lightBlueAccent,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
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
            icon: new Icon(Icons.history),
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
    );
  }
}
