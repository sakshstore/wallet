import 'package:flutter/material.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/providers/auth.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:jada/util/validators.dart';
import 'package:jada/util/widgets.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _username="";
  String  _password="";
  String  _confirmPassword="";

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final img_logo = Image.asset('images/alphakoin.png');

    final usernameField = TextFormField(
      autofocus: false,


      validator: (value) => value!.isEmpty ? "Please enter Email" : null,

      onSaved: (value) => _username = value!,
      decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Your password is required" : null,
      onSaved: (value) => _confirmPassword = value!,
      obscureText: true,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );


    var doRegister = () {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();



        final Future<Map<String, dynamic>> successfulMessage =
        auth.register(_username, _password, _confirmPassword);


        successfulMessage.then((response) {
          if ( response['status']) {
            Flushbar(
              title: "Register Success",
              message: "Register Success",
              duration: Duration(seconds: 3),
            ).show(context);

            User user = response['user'];

            //access_token
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Flushbar(
              title: "Register failure",
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };




    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                img_logo,
                SizedBox(height: 15.0),
                label("Email"),
                SizedBox(height: 5.0),
                usernameField,
                SizedBox(height: 15.0),
                label("Password"),
                SizedBox(height: 10.0),
                passwordField,
                SizedBox(height: 15.0),
                label("Confirm Password"),
                SizedBox(height: 10.0),
                confirmPassword,
                SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Login", doRegister),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
