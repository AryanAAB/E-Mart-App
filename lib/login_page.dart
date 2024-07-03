import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emartapp/constants.dart';
import 'package:emartapp/main.dart';
import 'package:emartapp/userService.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  MyApp app;

  LoginPage({Key? key, required this.app}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      widget.app.reset();
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      printError(context, 'Failed to sign in: Check email and password.');
    } catch(e) {
      printError(context, 'Failed to sign in: Check email and password.');
    }
  }

  void _forgotPassword() async {
    if (_emailController.text.isEmpty) {
      printError(context, "Please enter your email to reset your password.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      printMessage(context, "Password reset email sent.");
    } on FirebaseAuthException catch (e) {
      printError(context, "Error. Please check email address.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GrabNGo',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              ),
              style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
              ),
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  text: 'Forgot password?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    fontSize: 25
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _forgotPassword,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30
                  ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50),
              ),
            ),
            SizedBox(height: 40),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                ),
                children: [
                  TextSpan(
                    text: 'Sign up instead.',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  MyApp app;

  SignUpPage({Key? key, required this.app}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isPasswordVisible = false;

  void _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String collectionName = 'users';
      String? documentId = userCredential.user?.uid;
      CollectionReference collectionRef = firestore.collection(collectionName);

      Map<String, dynamic> data = {
        'cart': {},
        'favorites': []
      };

      await collectionRef.doc(documentId).set(data);
      widget.app.reset();
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        printError(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        printError(context, 'The account already exists for that email.');
      } else {
        printError(context, 'Failed to Sign up.');
      }
    } catch(e) {
      printError(context, 'Failed to Sign up.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GrabNGo',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
              ),
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 30
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50),
              ),
            ),
            SizedBox(height: 40),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
                children: [
                  TextSpan(
                    text: 'Login instead.',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/login');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
