// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_string_interpolations, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suivi/controllers/admin_controller.dart';
import 'package:suivi/models/workday.dart';

class UserAttendancePage extends StatelessWidget {
  final int userId;
  final AdminController controller = Get.find();
  Color primary = Colors.deepPurple;
  UserAttendancePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Appel de fetchUserAttendance après le build pour éviter les problèmes d'initialisation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserAttendance(userId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Présences de l'utilisateur",style: TextStyle(color: Colors.white))),
      body: Obx(() {
        if (controller.workdays.isEmpty) {
          return Center(child: Text("Aucune présence trouvée"));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: controller.workdays.length,
            itemBuilder: (context, index) {
              WorkDay workday = controller.workdays[index];
              return Column(
                children: [
          
                 Card(
                    margin: EdgeInsets.only(bottom: 20),
                    elevation: 4, // Ombre du Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.calendar_today, color: Colors.white, size: 24), 
                                    SizedBox(height: 10),
                                    Text(
                                      '${workday.date}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform.rotate(
                                  angle: 1.5708, // 90 degrés en radians (π/2)
                                  child: Icon(Icons.login, color: Colors.deepPurple, size: 24),
                                ), // Icône pour l'arrivée
                                SizedBox(height: 10), 
                                Text(
                                  workday.arrivalTime != null
                                      ? workday.arrivalTime!.substring(0, 5)
                                      : '--:--',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  Transform.rotate(
                                  angle: -1.5708, 
                                  child:Icon(Icons.logout, color: Colors.deepPurple, size: 24), // Icône pour le départ
                                  ),
                                SizedBox(height: 10), 
                                Text(
                                  workday.departureTime != null
                                      ? workday.departureTime!.substring(0, 5)
                                      : '--:--',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              );
            },
          ),
        );

        
      }),
    );
  }
}
