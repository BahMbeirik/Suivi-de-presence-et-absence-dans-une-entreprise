import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class WorkdaysController extends GetxController {
  var workdays = <dynamic>[].obs; // Liste des journées de travail (Observable)
  var isLoading = true.obs; 
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchWorkdays();
  }

  Future<void> fetchWorkdays() async {
    final token = box.read('token'); // Récupération du token JWT

    if (token == null) {
      Get.snackbar('Erreur', 'Token JWT manquant. Veuillez vous reconnecter.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.6:8000/api/workdays/'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        workdays.assignAll(data); // Mise à jour de la liste observable
      } else {
        Get.snackbar('Erreur', 'Erreur ${response.statusCode}: ${response.reasonPhrase}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Erreur réseau', 'Erreur réseau : $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false); 
    }
  }
}