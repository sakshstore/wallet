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

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

    String _newCPassword="";
    String _newPassword="";
    String _currentPassword="";


    AuthProvider auth = Provider.of<AuthProvider>(context);

    User user = Provider.of<UserProvider>(context).user;

    final currentPasswordField = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Please type your Currenct Password',
        labelText: 'Currt Password *',
      ),
      onSaved: (value) => _currentPassword = value!,
      keyboardType: TextInputType.text,
    );

    final newPasswordField = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Please type Your New Password',
        labelText: 'New Password *',
      ),
      onSaved: (value) => _newPassword = value!,
      keyboardType: TextInputType.text,
    );

    final newCPasswordField = TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Please Confirm Your New Password',
        labelText: 'New Confirm Password *',
      ),
      onSaved: (value) => _newCPassword = value!,
      keyboardType: TextInputType.text,
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    var sendRequest = () {
      final form = formKey.currentState;
      print("70");
      if (form!.validate()) {
        form.save();
        print("73");

        final Future<Map<String, dynamic>> successfulMessage =
            auth.updatepassword(_currentPassword, _newPassword, _newCPassword);

        successfulMessage.then((response) {
          print("87 ");

          Flushbar(
            title: "Login Success",
            message: "88",
            duration: Duration(seconds: 3),
          ).show(context);

          print(response.toString());

          print("99 ");

          var err = "false";

          if (err == "false") {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Flushbar(
              title: "Updation Failed",
              message: "Updation Failed",
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
          title: Text("Update Password"),
          elevation: 0.1,
        ),
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                label("Current Password"),
                SizedBox(height: 5.0),
                currentPasswordField,
                SizedBox(height: 20.0),
                label("New Password"),
                SizedBox(height: 5.0),
                newPasswordField,
                SizedBox(height: 20.0),
                label("Confirm new Password"),
                SizedBox(height: 5.0),
                newCPasswordField,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Update Password", sendRequest),
                SizedBox(height: 5.0),
                label("For any issue please message to support"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 4, // this will be set when a new tab is tapped
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
