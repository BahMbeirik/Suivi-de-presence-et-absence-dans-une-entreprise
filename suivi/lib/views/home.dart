// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suivi/constants/drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suivi/views/calandery.dart';
import 'package:suivi/views/profile.dart';
import 'package:suivi/views/today.dart';
import 'package:suivi/controllers/home_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController controller = Get.put(HomeController());

  Color primary = Colors.deepPurple;

  final List<Widget> pages = [
    Calandery(),
    Today(),
    Profile(),
  ];

  List<IconData> navigations = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Suivi", style: TextStyle(color: Colors.white)),
      ),
      drawer: appDrawer(context),
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          items: List.generate(
            navigations.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(navigations[index]),
              label: '',
            ),
          ),
        ),
      ),
    );
  }
}
