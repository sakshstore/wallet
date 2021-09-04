import 'package:flutter/material.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  final User? user;

  Welcome({  Key? key,    this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome you..."),
        elevation: 0.1,
      ),
      body: Container(
        child: Center(
          child: Text("Welcome you..."),
        ),
      ),
    );
  }
}
