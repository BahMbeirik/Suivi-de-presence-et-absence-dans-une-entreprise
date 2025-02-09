import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suivi/models/user.dart';
import 'package:suivi/models/workday.dart';
import 'package:http/http.dart' as http;

class AdminController extends GetxController {
  var users = <User>[].obs;
  var workdays = <WorkDay>[].obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('http://192.168.100.6:8000/api/admin/users/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      users.value = data.map((e) => User.fromJson(e)).toList();
    } else {
      Get.snackbar('Error', 'Failed to fetch users: ${response.statusCode}', snackPosition: SnackPosition.TOP);
      
    }
  }

  void fetchUserAttendance(int userId) async {
  final token = box.read('token');
  final response = await http.get(
    Uri.parse('http://192.168.100.6:8000/api/admin/user/$userId/attendance/'),
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    workdays.assignAll(data.map((e) => WorkDay.fromJson(e)).toList()); 
  } else {
    Get.snackbar('Erreur', 'Impossible de récupérer les présences: ${response.statusCode}', snackPosition: SnackPosition.TOP);
  }
}



}
