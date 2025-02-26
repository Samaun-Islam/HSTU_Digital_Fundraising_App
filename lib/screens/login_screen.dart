import 'package:finguard/Authintication/ForgetPasswordScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful!")),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Login")),
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

        child: Padding( // Added padding around the whole form
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(bottom: 130),
                child: Image.asset(
                  'assets/Images/logo5.png',
                  width: 350,
                  height: 100,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 150),
              //   child: Text('   HSTU \nDigiFund',style: TextStyle(color: Colors.white,fontSize: 40,),),
              // ),
              // SizedBox(height: 15),
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white), // Text inside the field
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white), // Label text color
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.white70), // Hint text color
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Border color when inactive
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2), // Border color when active
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white, // Cursor color
              ),

              SizedBox(height: 15), // Increased spacing

              TextField(
                controller: passwordController,
                style: TextStyle(color: Colors.white), // Text inside the field
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white), // Label text color
                  hintText: "Enter your Password",
                  hintStyle: TextStyle(color: Colors.white70), // Hint text color
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Border color when inactive
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2), // Border color when active
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white, // Cursor color
                obscureText: true,
              ),

              SizedBox(height: 20), // Increased spacing before buttons

              ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Added padding inside button
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: Text("Login", style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              SizedBox(height: 10), // Spacing between buttons

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: Text("Forgot Password?",style: TextStyle(fontSize: 15),),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),

              SizedBox(height: 50), // Added spacing before register link

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text("Don't have an account? RRRegister",style: TextStyle(fontSize: 17),),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
