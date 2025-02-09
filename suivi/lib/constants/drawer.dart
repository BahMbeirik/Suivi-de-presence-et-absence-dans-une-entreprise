// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suivi/routes/app_routes.dart';

Drawer appDrawer(BuildContext context) {
  final storage = GetStorage();
  final userRole = storage.read('role');

  // Function to handle logout
  void _logout() async {
  final confirmed = await showDialog<bool>(
    context: Get.context!,
    builder: (context) => AlertDialog(
      title: Text('Logout'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Get.back(result: true); 
          },
          child: Text('Logout'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final storage = GetStorage();
    await storage.erase();
    Get.offAllNamed('login'); 
  }
}

  Color primary = Colors.deepPurple;

  return Drawer(
    backgroundColor: primary,
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.jpeg"),
                fit: BoxFit.cover),
          ),
          currentAccountPicture: CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage("assets/images/logo1.png")),
          accountName: Text("Bahah M'beirik",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          accountEmail: Text("Bah008@gmail.com",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ),

        //  استخدام ListView داخل Expanded لمنع overflow
        Expanded(
          child: ListView(
            children: [
              if (userRole == 'admin')
              _buildListTile(context, "Admin", Icons.admin_panel_settings, Routes.admin),

              if (userRole == 'user')
              _buildListTile(context, "Home", Icons.home, Routes.home),
              
              _buildListTile(context, "Profile", Icons.person, Routes.profile),
              ListTile(
                title: Text('Logout',
                    style: TextStyle(
                      color: Color.fromARGB(255, 248, 68, 68),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                leading: Icon(Icons.exit_to_app, color: Color.fromARGB(255, 248, 68, 68)),
                onTap: () async {
                  Get.back(); 
                  await Future.delayed(Duration(milliseconds: 300)); 
                  _logout();
                },
              ),
            ],
          ),
        ),

      
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            "Developed by Bahah M'beirik © 2025",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

ListTile _buildListTile(BuildContext context, String title, IconData icon, String route) {
  return ListTile(
    title: Text(title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
    leading: Icon(icon, color: Colors.white),
    onTap: () {
      Get.toNamed(route);
    },
  );
}
