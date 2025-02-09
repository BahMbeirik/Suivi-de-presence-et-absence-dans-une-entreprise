// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final box = GetStorage();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Animation d'opacité
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    startTime();
  }

  startTime() {
    const duration = Duration(seconds: 3);
    Timer(duration, navigationPage);
  }

  void navigationPage() {
    final token = box.read('token');
    print('Token retrieved: $token');

    if (token != null) {
      String? role = box.read('role');
      if (role == 'admin') {
        Get.offNamed('/adminHome');
      } else if (role == 'user') {
        Get.offNamed('/home');
      }
    } else {
      Get.offNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Fond d'écran
          Image.asset(
            "assets/images/Confirmed_attendance.png",
            fit: BoxFit.cover,
          ),
          
          // Texte en bas de l'écran
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Suivi des présences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 146, 9, 146),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
