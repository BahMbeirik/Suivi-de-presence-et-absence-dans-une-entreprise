import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = box.read('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://192.168.100.6:8000/api/user/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      name.value = userData['username'];
      email.value = userData['email'];
      phone.value = userData['phone_number'];
    }
  }

  Future<void> updateProfile(String username, String email, String phone) async {
    final token = box.read('token');
    if (token == null) return;

    final response = await http.put(
      Uri.parse('http://192.168.100.6:8000/api/user/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'phone_number': phone,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Succès', 'Profil mis à jour avec succès', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Erreur', 'Erreur lors de la mise à jour du profil', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
