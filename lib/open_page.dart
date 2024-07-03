import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: Lottie.asset('assets/cart.json', width: 300, height: 300),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * _controller.value),
                  child: child,
                );
              },
            ),
            SizedBox(height: 30),
            Text(
              'GrabNGo',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {Navigator.pushReplacementNamed(context, '/login');},
              child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30
                  ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50),
              )
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {Navigator.pushReplacementNamed(context, '/signUp');},
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 30
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                )
            ),
          ],
        ),
      ),
    );
  }
}