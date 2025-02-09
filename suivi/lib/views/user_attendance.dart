// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suivi/controllers/admin_controller.dart';
import 'package:suivi/models/workday.dart';

class UserAttendancePage extends StatelessWidget {
  final int userId;
  final AdminController controller = Get.find();

  UserAttendancePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Appel de fetchUserAttendance après le build pour éviter les problèmes d'initialisation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserAttendance(userId);
    });

    return Scaffold(
      appBar: AppBar(title: Text("Présences de l'utilisateur")),
      body: Obx(() {
        if (controller.workdays.isEmpty) {
          return Center(child: Text("Aucune présence trouvée"));
        }
        return ListView.builder(
          itemCount: controller.workdays.length,
          itemBuilder: (context, index) {
            WorkDay workday = controller.workdays[index];
            return Column(
              children: [

               Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Date',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text('${workday.date}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          )),
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
                                  Text('Arrivée',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black38)),
                                  Text(
                                        workday.arrivalTime != null 
                                        ? workday.arrivalTime!.substring(0, 5) 
                                        : '--:--',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                            
                            
                                ],
                              ),
                               ),
                               Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Départ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black38)),
                                  Text(
                                        workday.departureTime != null 
                                        ? workday.departureTime!.substring(0, 5) 
                                        : '--:--',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        );

        
      }),
    );
  }
}
