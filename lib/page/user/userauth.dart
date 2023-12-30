

import 'package:flutter/material.dart';


class UserAuth extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic> _userData = {}; // Store user data in a map

  bool get isLoggedIn => _isLoggedIn;

  Map<String, dynamic> get userData => _userData; // Getter for user data

  void setLoggedIn(bool value, {Map<String, dynamic>? userData}) {
    _isLoggedIn = value;
    if (value && userData != null) {
      _userData = userData; // Set user data if logging in
    } else {
      _userData = {}; // Clear user data if logging out
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userData = {}; // Clear user data on logout
    notifyListeners();
  }
}