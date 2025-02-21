import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent! Check your email.")),
      );
      Navigator.pop(context); // Go back to login screen after sending the email
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0F2027), // Almost Black
              Color(0xff203A43), // Dark Teal
              Color(0xff2C5364),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  "Enter your email and we'll send you a password reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email",labelStyle: const TextStyle(color: Colors.white),),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetPassword,
                child: Text("Reset Password"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to Login Screen
                },
                child: Text("Back to Login"),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
