import 'dart:async';
import 'package:dummy_project/services/login_service.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
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
      body: ResponsiveLayout.builder(
        breakpoints: ResponsiveBreakpoints(tablet: 600, tabletInclusive: false),
        builder: (context, size, constraints) {
          if (size != ResponsiveSize.mobile) {
            return _buildSplash(
              iconSize: 130,
              titleSize: 26,
              subtitleSize: 18,
              spacing: 35,
            );
          } else {
            return _buildSplash(
              iconSize: 100,
              titleSize: 20,
              subtitleSize: 15,
              spacing: 28,
            );
          }
        },
      ),
    );
  }

  Widget _buildSplash({
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
    required double spacing,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: iconSize,
            width: iconSize,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              Icons.shopping_bag,
              size: iconSize * 0.58,
              color: Colors.white,
            ),
          ),
          SizedBox(height: spacing),
          Text(
            'JONSTORE',
            style: TextStyle(
              color: Colors.black,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start Your Journey',
            style: TextStyle(
              color: Colors.grey,
              fontSize: subtitleSize,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: spacing + 17),
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
    );
  }
}
