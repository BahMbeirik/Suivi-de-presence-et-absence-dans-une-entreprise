import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodayController extends GetxController {
  var arrivalTime = '--:--'.obs;
  var departureTime = '--:--'.obs;
  var isDayStarted = false.obs;
  var isDayEnded = false.obs;
  var userName = 'Utilisateur'.obs;
  var currentTime = ''.obs;

  final box = GetStorage(); 

  @override
  void onInit() {
    super.onInit();
    fetchTodayData();
    _updateTime();
  }

  
  void _updateTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }


  Future<void> fetchTodayData() async {
    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Erreur', 'Token JWT manquant', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final todayResponse = await http.get(
        Uri.parse('http://192.168.100.6:8000/api/today/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final userResponse = await http.get(
        Uri.parse('http://192.168.100.6:8000/api/user/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (todayResponse.statusCode == 200 && userResponse.statusCode == 200) {
        final todayData = json.decode(todayResponse.body);
        final userData = json.decode(userResponse.body);

        arrivalTime.value = todayData['arrivalTime'] ?? '--:--';
        departureTime.value = todayData['departureTime'] ?? '--:--';
        isDayStarted.value = arrivalTime.value != '--:--';
        isDayEnded.value = departureTime.value != '--:--';
        userName.value = userData['username'] ?? 'Utilisateur';
      } else {
        Get.snackbar('Erreur', 'Impossible de récupérer les données', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur réseau : $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  
  Future<void> startDay() async {
    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Erreur', 'Token JWT manquant', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.6:8000/api/start-day/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'arrivalTime': DateFormat('HH:mm').format(DateTime.now())}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        arrivalTime.value = data['arrivalTime'];
        isDayStarted.value = true;
        Get.snackbar('Succès', 'Journée démarrée avec succès.', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Erreur', 'Erreur lors du démarrage', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur réseau : $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  
  Future<void> endDay() async {
    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Erreur', 'Token JWT manquant', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.6:8000/api/end-day/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'departureTime': DateFormat('HH:mm').format(DateTime.now())}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        departureTime.value = data['departureTime'];
        isDayEnded.value = true;
        Get.snackbar('Succès', 'Journée terminée avec succès.', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Erreur', 'Erreur lors de la fin de la journée.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur réseau : $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
