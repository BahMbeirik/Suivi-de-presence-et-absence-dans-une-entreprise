// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:suivi/controllers/today_controller.dart';

class Today extends StatelessWidget {
  Today({super.key});

  final TodayController controller = Get.find<TodayController>(); // Injection du contrôleur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            
            Obx(() => Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bienvenue ${controller.userName.value}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                )),
            SizedBox(height: 20),

            
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'La situation d\'aujourd\'hui',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ✅ Carte d'affichage de l'arrivée et départ
            Obx(() => Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  height: 150,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Arrivée',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              controller.arrivalTime.value,
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
                            Text(
                              'Départ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              controller.departureTime.value,
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
                )),

            
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: DateTime.now().day.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            
            Obx(() => Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    controller.currentTime.value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                )),

            SizedBox(height: 20),

            
            Obx(() {
              if (!controller.isDayStarted.value) {
                return SlideAction(
                  text: 'Glisser pour démarrer la journée',
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  innerColor: Colors.deepPurple,
                  outerColor: Colors.white,
                  onSubmit: () async {
                    await controller.startDay();
                  },
                );
              }
              if (controller.isDayStarted.value && !controller.isDayEnded.value) {
                return SlideAction(
                  text: 'Glisser pour terminer la journée',
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  innerColor: Colors.red,
                  outerColor: Colors.white,
                  onSubmit: () async {
                    await controller.endDay();
                  },
                );
              }
              return Text(
                'Vous avez terminé cette journée',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
