

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class UserAuth extends ChangeNotifier {
  bool _isLoggedIn = false;
  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;
  Map<String, dynamic> _userData = {}; // Store user data in a map

  bool get isLoggedIn => _isLoggedIn;

  Map<String, dynamic> get userData => _userData; // Getter for user data
  void updateUserData(Map<String, dynamic> newUserData) {
    _userData = newUserData;
    notifyListeners();
  }
  void updateUser(GoogleSignInAccount? account) {
    _currentUser = account;
    notifyListeners();
  }
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