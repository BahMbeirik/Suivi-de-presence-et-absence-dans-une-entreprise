import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordController extends GetxController {
  var phoneNumber = ''.obs;
  var otp = ''.obs;
  var newPassword = ''.obs;
  var otpSent = false.obs;
  final isPasswordVisible = false.obs;

void togglePasswordVisibility() {
  isPasswordVisible.value = !isPasswordVisible.value;
}

  Future<void> sendOTP() async {
    final response = await http.post(
      Uri.parse('http://192.168.100.6:8000/api/forgot-password/'),
      body: json.encode({'phone_number': phoneNumber.value}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      otpSent.value = true;
      Get.snackbar("Succès", "OTP envoyé avec succès !");
    } else {
      Get.snackbar("Erreur", "Échec de l'envoi de l'OTP");
    }
  }

  Future<void> verifyOTPAndResetPassword() async {
    final response = await http.post(
      Uri.parse('http://192.168.100.6:8000/api/reset-password/'),
      body: json.encode({
        'phone_number': phoneNumber.value,
        'otp': otp.value,
        'new_password': newPassword.value,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Get.snackbar("Succès", "Mot de passe réinitialisé !");
      Get.offAllNamed('/login'); 
    } else {
      Get.snackbar("Erreur", "Échec de la réinitialisation du mot de passe");
    }
  }
}
