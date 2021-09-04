import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jada/domain/user.dart';
import 'package:jada/util/app_url.dart';
import 'package:jada/util/shared_preference.dart';

import 'package:jada/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppUrl.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("the er espons sponse.statusCode");

      final Map<String, dynamic> responseData = json.decode(response.body);

      var data = json.decode(response.body);



      String code = responseData['ErrorCode'].toString();



      if (code == "100") {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('access_token', data['access_token'].toString());

        print(responseData['user']['email'].toString());

        print(data['user']['id'].toString());

        print(responseData['user']['email'].toString());

        print(data['user']['id'].toString());

        print(responseData['user']['email'].toString());

        print(80);

        var userData = responseData['user'];

        User authUser = User.fromJson(userData);

        UserPreferences().saveUser(authUser);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(response.body)['Error']
        };
      }
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['Error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String passwordConfirmation) async {
    var result;

    final Map<String, dynamic> registrationData = {
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppUrl.register),
      body: json.encode(registrationData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {


      final Map<String, dynamic> responseData = json.decode(response.body);

      var data = json.decode(response.body);


      String code = responseData['ErrorCode'].toString();

      if (code == "100") {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('access_token', data['access_token'].toString());

        var userData = responseData['user'];

        User authUser = User.fromJson(userData);

        UserPreferences().saveUser(authUser);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(response.body)['message']
        };
      }
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> updatepassword(String _currentPassword,
      String _newPassword, String _newCPassword) async {
    var result;

    final Map<String, dynamic> loginData = {
      'confirm_password': _newCPassword,
      'new_password': _newPassword,
      'current_password': _currentPassword
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String access_token = prefs.getString('access_token')!;

    Response response = await post(
      Uri.parse(AppUrl.updatepassword),
      body: json.encode(loginData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access_token'
      },
    );

    if (response.statusCode == 200) {
      print("140   140");

      final Map<String, dynamic> responseData = json.decode(response.body);

      var data = json.decode(response.body);

      print(data['message'].toString());

      print(data['Error'].toString());
      print("149  149 ");

      var er = "true";

      if (er == "true") {
        result = {'status': true, 'message': data['message'].toString()};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': data['message'].toString()};
      }
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': "failure "};
    }

    print("166 166  ");

    return result;
  }



  Future<Map<String, dynamic>> sendFund(
      String _amount, String _receiptAddress) async {
    print(132);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(135);
    String access_token = prefs.getString('access_token')!;

    print(access_token);
    print(139);
    final Map<String, dynamic> sendFundData = {
      'amount': _amount,
      'toAddress': _receiptAddress
    };
    Response response = await post(
      Uri.parse(AppUrl.sendFund),
      body: json.encode(sendFundData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access_token'
      },
    ) ;


    if (response.statusCode == 200) {
      String data = response.body;


      return jsonDecode(data);


    } else {
      print(response.statusCode);

     return  {'status': false, 'message': "failure "};


    }



  }

  Future<Map<String, dynamic>> getTransactions() async {
    print(132);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(135);
    String access_token = prefs.getString('access_token')!;

    print(access_token);
    print(139);
    final Map<String, dynamic> getTransactionsData = {'limit': 100};


    Response response = await post(
      Uri.parse(AppUrl.sendFund),
      body: json.encode(getTransactionsData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access_token'
      },
    ) ;


    if (response.statusCode == 200) {
      String data = response.body;


      return jsonDecode(data);


    } else {

      return  {'status': false, 'message': "failure "};


    }




  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 200) {
      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
