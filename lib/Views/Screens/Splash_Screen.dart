import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vpn_app/Views/Screens/HomeScreen.dart';
import 'package:vpn_app/Views/constant.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create a curved animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _controller.forward();

    // Navigate to home screen after delay
    Timer(
        const Duration(milliseconds: 2500),
            () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
        )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      body: Stack(
        children: [
          // Background gradient circles
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00BCD4).withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00BCD4).withOpacity(0.07),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animation
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2C45),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BCD4).withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(0),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BCD4).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover, // Fill the entire space, may stretch the image
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // App name with animation
                Text(
                  'Wrap VPN'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ).animate().fade(duration: 800.ms, delay: 300.ms).slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 800.ms,
                  delay: 300.ms,
                  curve: Curves.easeOutQuad,
                ),

                SizedBox(height: 10),

                // Tagline with animation
                Text(
                  'Secure. Fast. Private.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ).animate().fade(duration: 800.ms, delay: 600.ms).slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 800.ms,
                  delay: 600.ms,
                  curve: Curves.easeOutQuad,
                ),

                SizedBox(height: 60),

                // Loading indicator
                Container(
                  width: 200,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2C45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF00BCD4),
                                const Color(0xFF00BCD4).withOpacity(0.7),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Version info
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              'v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
