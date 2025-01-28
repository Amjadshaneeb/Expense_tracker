import 'package:expense_tracker_app/presentation/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _statusMessage = '';

  bool get isLoggedIn => _isLoggedIn;
  String get statusMessage => _statusMessage;

 Future<void> loadLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _isLoggedIn = prefs.getBool('isLoggedIn') ?? false; 
  notifyListeners();
}


  Future<void> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedEmail = prefs.getString('registeredEmail');
    String? storedPassword = prefs.getString('registeredPassword');

    if (storedEmail != null &&
        storedPassword != null &&
        email == storedEmail &&
        password == storedPassword) {
      await prefs.setBool('isLoggedIn', true);
      _isLoggedIn = true;
      _statusMessage = 'Login successful!';
    } else {
      _statusMessage = 'Invalid email or password';
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    _statusMessage = 'Logged out successfully';
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  Future<void> register(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('registeredEmail', email);
      await prefs.setString('registeredPassword', password);

      _statusMessage = 'Registration successful!';
    } else {
      _statusMessage = 'Please enter valid email and password';
    }
    notifyListeners();
  }
}
