import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:share_plus/share_plus.dart';


import 'package:shared_preferences/shared_preferences.dart';


import 'dart:convert';


import 'package:http/http.dart' as http;



class MainPage extends StatefulWidget
{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
{

  String balance = "";
  String address = "";
  String last_login_ip = "";
  String last_login = "";


  Future<String> getDashboard() async {
    String link = "https://wapi.alphakoin.io/api/v3/wallet/Dashboard";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(22);
    String access_token = prefs.getString('access_token')!;

    var res = await http.get(    Uri.parse(link), headers: {
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
  Widget build(BuildContext context)
  {
    return Scaffold
      (

        appBar: AppBar(
          title: Text("Alphakoin Wallet"),
          elevation: 0.1,
        ),

        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Balance', style: TextStyle(color: Colors.blueAccent)),
                          Text(balance, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white, size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ), onTap: () {  },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Material
                        (
                          color: Colors.teal,
                          shape: CircleBorder(),
                          child: Padding
                            (
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.settings_applications, color: Colors.white, size: 30.0),
                          )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text('General', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                      Text('Images, Videos', style: TextStyle(color: Colors.black45)),
                    ]
                ),
              ), onTap: () {  },
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Column
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Material
                        (
                          color: Colors.amber,
                          shape: CircleBorder(),
                          child: Padding
                            (
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.notifications, color: Colors.white, size: 30.0),
                          )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text( last_login , style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                      Text( last_login_ip , style: TextStyle(color: Colors.black45)),
                    ]
                ),
              ), onTap: () {  },
            ),



          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(2, 220.0),
            StaggeredTile.extent(2, 110.0),
          ],
        ),

        floatingActionButton: new FloatingActionButton(
          onPressed: last_login.isEmpty
              ? null
              : () => _onShare(context),
    child: new Icon(Icons.refresh),
    ),


    );
  }

  Widget _buildTile(Widget child, {required Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }


void _onShare(BuildContext context) async {
  // A builder is used to retrieve the context immediately
  // surrounding the ElevatedButton.
  //
  // The context's `findRenderObject` returns the first
  // RenderObject in its descendent tree when it's not
  // a RenderObjectWidget. The ElevatedButton's RenderObject
  // has its position and size after it's built.
  final box = context.findRenderObject() as RenderBox ?;

  await Share.share(last_login,
        subject: last_login,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

}
}
