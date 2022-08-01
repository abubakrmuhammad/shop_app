import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

const _apiKey = 'AIzaSyBlk4tNDIJSddyfPuXjScig544ldsXihy8';

enum _AuthType { signup, login }

const authDataKey = 'authData';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;

  bool get isAuthenticated {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) return _token;

    return null;
  }

  Future<void> _authenticate(
      String email, String password, _AuthType authType) async {
    final urlSegment =
        authType == _AuthType.login ? 'signInWithPassword' : 'signUp';

    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_apiKey',
    );

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final prefs = await SharedPreferences.getInstance();
      final authData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      await prefs.setString(authDataKey, authData);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(authDataKey)) return false;

    final authData = json.decode(prefs.getString(authDataKey)!) as Map;
    final expiryDate = DateTime.parse(authData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = authData['token'];
    _userId = authData['authData'];
    _expiryDate = expiryDate;

    notifyListeners();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, _AuthType.signup);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, _AuthType.login);
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(authDataKey);
  }
}
