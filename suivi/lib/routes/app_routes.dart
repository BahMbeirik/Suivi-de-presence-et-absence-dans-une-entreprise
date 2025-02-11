// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:suivi/views/admin_home.dart';
import 'package:suivi/views/forgot_password.dart';
import 'package:suivi/views/home.dart';
import 'package:suivi/views/login.dart';
import 'package:suivi/views/profile.dart';
import 'package:suivi/views/register.dart';
import 'package:suivi/views/splashscreen.dart';
import 'package:suivi/views/user_attendance.dart';
import 'package:suivi/views/verify_otp.dart';

class AppPages {
  static const initial = Routes.splashscreen;

  static final routes = [
    GetPage(name: Routes.splashscreen, page: () => SplashScreen()),
    GetPage(name: Routes.login, page: () => KeyboardVisibilityProvider(child: Login())),
    GetPage(name: Routes.register, page: () => Register()),
    GetPage(name: Routes.verifyOtp, page: () => VerifyOtp()),
    GetPage(name: Routes.home, page: () => Home()),
    GetPage(name: Routes.profile, page: () => Profile()),
    GetPage(name: Routes.admin, page: () => AdminPage()),
    GetPage(name: Routes.userAttendance, page: () => UserAttendancePage(userId: Get.arguments)),
    GetPage(name: Routes.forgotPassword, page: () => ForgotPasswordPage()),
  ];
}

class Routes {
  static const splashscreen = '/splashscreen';
  static const login = '/login';
  static const register = '/register';
  static const verifyOtp = '/verifyOtp';
  static const home = '/home';
  static const admin = '/adminHome';
  static const userAttendance = '/userAttendance';
  static const profile = '/profile';
  static const forgotPassword = '/forgotPassword';
}
