// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suivi/controllers/verifyotp_controller.dart';

class VerifyOtp extends StatelessWidget {
  const VerifyOtp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final verifyOtpController = Get.put(VerifyOtpController());
    final GetStorage storage = GetStorage();
    late String phoneNumber;

    // Get phone number from arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    phoneNumber = args['phoneNumber'] as String;

    Future<void> verifyOtp() async {
      final String completeOtp = verifyOtpController.otpCode.join();
      if (completeOtp.length != 6) {
        Get.snackbar('Error', 'Please enter all 6 digits', snackPosition: SnackPosition.TOP);
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('http://192.168.100.6:8000/api/verify-otp/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'phone_number': phoneNumber,
            'otp': completeOtp,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['token'] != null) {
            await storage.write('token', data['token']);
            String? role = storage.read('role');
            if (role == 'admin') {
              Get.offNamed('/adminHome');
            } else if (role == 'user') {
              Get.offNamed('/home');
            }
          } else {
            Get.snackbar('Error', 'Invalid OTP. Please try again.', snackPosition: SnackPosition.TOP);
          }
        } else {
          Get.snackbar('Error', 'Failed to verify OTP. Please try again.', snackPosition: SnackPosition.TOP);
        }
      } catch (e) {
        Get.snackbar('Error', 'Network error: Please try again later.', snackPosition: SnackPosition.TOP);
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 122, 23, 140),
              Color.fromARGB(255, 139, 17, 209),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please type the verification code sent to +222 $phoneNumber',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => Container(
                      width: 40,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Obx(() {
                          return Text(
                            verifyOtpController.otpCode[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:  verifyOtp ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 85, 1, 134),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verify now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              // Number pad
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: EdgeInsets.all(48),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: List.generate(12, (index) {
                    if (index == 9) return Container();
                    if (index == 10) {
                      return buildNumberKey('0', verifyOtpController);
                    }
                    if (index == 11) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.backspace, color: Colors.white),
                          onPressed: verifyOtpController.onBackspace,
                        ),
                      );
                    }
                    return buildNumberKey('${index + 1}', verifyOtpController);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNumberKey(String number, VerifyOtpController controller) {
    return InkWell(
      onTap: () => controller.onNumberPress(number),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
