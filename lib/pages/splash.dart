import 'dart:async';
import 'package:dummy_project/pages/login.dart';
import 'package:dummy_project/services/loginservice.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () async {
      if (!mounted) return;
      await roleCheck(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(Icons.shopping_bag, size: 58, color: Colors.white),
            ),
            SizedBox(height: 28),
            Text(
              'JONSTORE',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),

            SizedBox(height: 8),
            Text(
              'Start Your Journey',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                letterSpacing: 1,
              ),
            ),

            SizedBox(height: 45),
            SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
