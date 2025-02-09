// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suivi/controllers/calandery_controller.dart';

class Calandery extends StatelessWidget {
  final WorkdaysController controller = Get.put(WorkdaysController()); // Injection du contrôleur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator()); 
        }

        if (controller.workdays.isEmpty) {
          return Center(child: Text('Aucun enregistrement trouvé.')); 
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Text('Ma présence',
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.workdays.length,
                  itemBuilder: (context, index) {
                    final workday = controller.workdays[index];
                    return WorkdayCard(workday: workday);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// Widget pour afficher une journée de travail
class WorkdayCard extends StatelessWidget {
  final dynamic workday;

  const WorkdayCard({Key? key, required this.workday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        Text('${workday['date']}',
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
                          workday['arrival_time'] != null 
                            ? workday['arrival_time'].substring(0, 5) 
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
                          workday['departure_time'] != null 
                            ? workday['departure_time'].substring(0, 5) 
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
  }
}