// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suivi/controllers/admin_controller.dart';
import 'package:suivi/models/user.dart';
import 'package:suivi/views/user_attendance.dart';
import 'package:suivi/constants/drawer.dart';

class AdminPage extends StatelessWidget {
  final AdminController controller = Get.put(AdminController()); // Injection du contrôleur
  Color primary = Colors.deepPurple;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Liste des utilisateurs",
            style: TextStyle(color: Colors.white)),
      ),
      drawer: appDrawer(context),
      body: Obx(() {
        if (controller.users.isEmpty) {
          return Center(child: Text("Aucun utilisateur trouvé"));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              User user = controller.users[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.white : Colors.grey[100],
                  border: Border(
                      bottom: BorderSide(color: Colors.deepPurple.shade100)
                  ),
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                child: ListTile(
                  title: Text('${user.username} -- ${user.phoneNumber}'),
                  subtitle: Text(user.email),
                  onTap: () {
                    Get.to(() => UserAttendancePage(userId: user.id));
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
