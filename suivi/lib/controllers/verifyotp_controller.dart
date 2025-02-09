import 'package:get/get.dart';

class VerifyOtpController extends GetxController {
  var otpCode = List.filled(6, '').obs; // Reactive list for OTP input
  var currentIndex = 0.obs;

  void onNumberPress(String number) {
    if (currentIndex < 6) {
      otpCode[currentIndex.value] = number;
      currentIndex.value++;
    }
  }

  void onBackspace() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      otpCode[currentIndex.value] = '';
    }
  }

  
}
