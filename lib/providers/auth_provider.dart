import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLogin = false;
  bool _isLoading = true;
  String _username = '';

  // Getter untuk diakses oleh UI
  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;
  String get username => _username;

  // Memeriksa status login saat aplikasi pertama kali dibuka
  Future<void> checkLoginCheck() async {
    final prefs = await SharedPreferences.getInstance();
    _isLogin = prefs.getBool('isLogin') ?? false;
    _username = prefs.getString('username') ?? '';
    _isLoading = false;
    notifyListeners(); // Memberitahu UI untuk update tampilan
  }

  // Fungsi Login
  Future<bool> login(String username, String password) async {
    // Validasi sederhana: pastikan tidak kosong dan password maks 8 karakter
    if (username.isEmpty || password.isEmpty) {
      return false;
    }
    
    if (password.length > 8) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
    await prefs.setString('username', username);

    _isLogin = true;
    _username = username;
    notifyListeners();
    return true;
  }

  // Fungsi Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isLogin = false;
    _username = '';
    notifyListeners();
  }
}