import 'package:flutter/material.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:jada/providers/auth.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

    List transactions=[];

    AuthProvider auth = Provider.of<AuthProvider>(context);

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

    @override
    void initState() {
      super.initState();
      transactions = auth.getTransactions() as List;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Transactions "),
          elevation: 0.1,
        ),
        body: new ListView.builder(
          itemCount: transactions == null ? 0 : transactions.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Text(transactions[index]["title"]),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2, // this will be set when a new tab is tapped
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
