import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _storage = StorageService();

  void _handleAuth(bool isSignup) async {
    bool success = isSignup 
      ? await _storage.signup(_emailController.text, _passController.text)
      : await _storage.login(_emailController.text, _passController.text);
    
    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Auth Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => _handleAuth(false), child: Text("Login")),
            TextButton(onPressed: () => _handleAuth(true), child: Text("Create Account")),
          ],
        ),
      ),
    );
  }
}