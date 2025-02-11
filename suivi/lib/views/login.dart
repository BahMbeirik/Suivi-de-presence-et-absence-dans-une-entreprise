// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nController = TextEditingController();
  TextEditingController passController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromARGB(255, 122, 23, 140);
  final box = GetStorage(); // Initialisation de GetStorage

  void loginUser() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.6:8000/api/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone_number': nController.text,
          'password': passController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'OTP sent for login verification.') {
          box.write('role', data['role']);
          Get.toNamed('/verifyOtp', arguments: {
            'phoneNumber': nController.text,
          });
        } else {
          
          Get.snackbar(
            'Error', // Title of the snackbar
            data['error'] ?? 'Login failed!', // Message
            snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
          );
        }
      } else {
        Get.snackbar(
          'Error', 
          'Login failed! Status Code: ${response.statusCode}', 
          snackPosition: SnackPosition.BOTTOM,
        );
        
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Network error: Please try again later.', 
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          isKeyboardVisible
              ? SizedBox(height: screenHeight / 16)
              : Container(
                  height: screenHeight / 3,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      )),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth / 4,
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(
              top: screenHeight / 15,
              bottom: screenHeight / 20,
            ),
            child: Text(
              'Login',
              style: TextStyle(
                  fontSize: screenWidth / 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NexaBold'),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth / 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fildTitle('Numero Tel :'),
                customField('Saisie Votre Numero', nController, false,
                    keyboard: TextInputType.phone,
                    Icon(
                      Icons.person,
                      color: primary,
                      size: screenWidth / 15,
                    )),
                fildTitle('Mot de Passe :'),
                customField('Saisie Votre Mot de Passe', passController, true,
                    keyboard: TextInputType.visiblePassword,
                    Icon(
                      Icons.password,
                      color: primary,
                      size: screenWidth / 15,
                    )),
                SizedBox(
                  height: screenHeight / 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primary,
                      padding: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: loginUser,
                    child: Text(
                      'SE CONNECTER',
                      style: TextStyle(
                        fontSize: screenWidth / 18,
                        color: Colors.white,
                        fontFamily: 'NexaBold',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, 
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed('forgotPassword');
                      },
                      child: Text('Mot de Passe Oublié'),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 60,
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('register');
                  },
                  child: Text('I don\'t have an account Sign up'),
                ),
              ],
            ),
          )
        ]));
  }

  Widget fildTitle(String title) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 12,
      ),
      child: Text(title,
          style: TextStyle(
              fontSize: screenWidth / 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'NexaBold')),
    );
  }

  Widget customField(String hint, TextEditingController controller, bool obscure,
      Icon icon, {required TextInputType keyboard}) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(2, 2))
          ]),
      child: Row(children: [
        Container(
          width: screenWidth / 8,
          child: icon,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: screenWidth / 12,
            ),
            child: TextFormField(
              keyboardType: keyboard,
              controller: controller,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenWidth / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: screenWidth / 26,
                  )),
              maxLines: 1,
              obscureText: obscure,
            ),
          ),
        ),
      ]),
    );
  }
}
