// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  Color primary = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Mot de Passe Oublié',style: TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Title Section
                Text(
                  'Réinitialisation du mot de passe',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Phone Number Input
                TextField(
                  onChanged: (value) => controller.phoneNumber.value = value,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    hintText: 'Entrez votre numéro de téléphone',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),

                // Dynamic OTP Section
                Obx(() {
                  if (!controller.otpSent.value) {
                    return ElevatedButton(
                      onPressed: controller.sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Envoyer OTP',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                            color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        // OTP Input
                        TextField(
                          onChanged: (value) => controller.otp.value = value,
                          decoration: InputDecoration(
                            labelText: 'Entrez OTP',
                            hintText: 'Saisissez le code reçu',
                            prefixIcon: const Icon(Icons.lock_clock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                        const SizedBox(height: 20),
                        
                        // New Password Input
                        Obx(() => TextField(
                          onChanged: (value) => controller.newPassword.value = value,
                          decoration: InputDecoration(
                            labelText: 'Nouveau mot de passe',
                            hintText: 'Entrez votre nouveau mot de passe',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value 
                                    ? Icons.visibility 
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => controller.togglePasswordVisibility(),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          obscureText: !controller.isPasswordVisible.value,
                        )),
                        const SizedBox(height: 24),
                        
                        // Reset Password Button
                        ElevatedButton(
                          onPressed: controller.verifyOTPAndResetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_reset, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Réinitialiser le mot de passe',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
    );
  }
}
