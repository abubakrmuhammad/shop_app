import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

const _apiKey = 'AIzaSyBlk4tNDIJSddyfPuXjScig544ldsXihy8';

enum _AuthType { signup, login }

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

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, _AuthType.signup);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, _AuthType.login);
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;

    notifyListeners();
  }
}
