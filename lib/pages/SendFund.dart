import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/providers/auth.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:jada/util/validators.dart';
import 'package:jada/util/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendFund extends StatefulWidget {
  @override
  _SendFundState createState() => _SendFundState();
}

class _SendFundState extends State<SendFund> {
  String balance = "";
  String address = "";
  Future<String> getBalance() async {
    String link = "https://ukbestdeal.com/api/wallet/Balance";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(22);
    String? access_token = prefs.getString('access_token');

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

    balance = "Balance Loading....";

    getBalance().then((val) {
      var data = json.decode(val);

      balance = "Balance " + data['balance'];

      address = data['address'];

      print(51);
      print("success");

      setState(() {});
    }).catchError((error, stackTrace) {
      print(57);
      print("outer: $error");
    });

    print(74);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

    String _amount, _receiptAddress;
    _amount="";

     _receiptAddress="";

    AuthProvider auth = Provider.of<AuthProvider>(context);

    User user = Provider.of<UserProvider>(context).user;

    final amountField = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.sd_card),
        hintText: 'How much amount you wish to send?',
        labelText: 'Amount *',
      ),
      onSaved: (value) => _amount = value!,
      keyboardType: TextInputType.number,
    );

    final addressField = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.receipt),
        hintText: 'Address where you wish to send?',
        labelText: 'Receipt Address *',
      ),
      onSaved: (value) => _receiptAddress = value!,
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text("Processing ... Please wait")
      ],
    );

    var doSend = () {
      final form = formKey.currentState;
      print("70");
      if (form!.validate()) {
        form.save();
        print("73");

        final Future<Map<String, dynamic>> successfulMessage =
            auth.sendFund(_amount, _receiptAddress);

        Flushbar(
          title: "Login Success",
          message: "79",
          duration: Duration(seconds: 3),
        ).show(context);

        print("76");
        successfulMessage.then((response) {
          Flushbar(
            title: "Login Success",
            message: "88",
            duration: Duration(seconds: 3),
          ).show(context);

          print(response.toString());

          Flushbar(
            title: "Login Success",
            message: "96",
            duration: Duration(seconds: 3),
          ).show(context);

          var err = "false";

          if (err == "false") {
            User user = response['user'];

            //access_token
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/sendfund');
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message']['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Send Fund "),
          elevation: 0.1,
        ),
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                label("Welcome " + user.email!??''),
                SizedBox(height: 15.0),
                label("Amount"),
                SizedBox(height: 5.0),
                amountField,
                SizedBox(height: 15.0),
                label("Maximum " + balance),
                SizedBox(height: 20.0),
                label("Receipt Address"),
                SizedBox(height: 5.0),
                addressField,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Send Fund", doSend),
                SizedBox(height: 5.0),
                label("For any issue please message to support"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1, // this will be set when a new tab is tapped
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
      ),
    );
  }
}
