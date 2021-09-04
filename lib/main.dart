import 'package:flutter/material.dart';
import 'package:jada/pages/dashboard.dart';
import 'package:jada/pages/login.dart';
import 'package:jada/pages/register.dart';
import 'package:jada/pages/welcome.dart';

import 'package:jada/pages/login_history.dart';

import 'package:jada/pages/SendFund.dart';

import 'package:jada/pages/changepassword.dart';

import 'package:jada/pages/Notifications.dart';

import 'package:jada/pages/newdashboard.dart';

import 'package:jada/providers/auth.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:jada/util/shared_preference.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Alphakoin Wallet',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else {
                      final user=snapshot.data as User;
                      if (user.token!=null &&user.token!.isNotEmpty)
                        return Login();
                      else
                        UserPreferences().removeUser();
                      return Welcome(user:user);
                    }
                }
              }),
          routes: {
            '/dashboard': (context) => MainPage(),
            '/loginhistory': (context) => LoginHistory(),
            '/Notifications': (context) => Notifications(),
            '/sendfund': (context) => SendFund(),
            '/transactions': (context) => Notifications(),
            '/changepassword': (context) => ChangePassword(),
            '/login': (context) => Login(),
            '/settings': (context) => LoginHistory(),
            '/register': (context) => Register(),
          }),
    );
  }
}
