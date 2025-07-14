import 'dart:developer';

import 'package:astronacci_fe/app/data/models/user_model.dart';
import 'package:astronacci_fe/app/data/services/auth_services.dart';
import 'package:astronacci_fe/app/modules/authentication/views/login_page_view.dart';
import 'package:astronacci_fe/app/modules/home/controllers/home_controller.dart';
import 'package:astronacci_fe/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationController extends GetxController {
  final AuthService _authService = AuthService();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController displayNameController;
  UserModel? userModel;

  // ----- regex variable -----
  bool isEmail(String input) => RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(input);
  bool get hasUppercase => password.value.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => password.value.contains(RegExp(r'[a-z]'));
  bool get hasDigit => password.value.contains(RegExp(r'\d'));
  // --------------------------
  final box = GetStorage();
  var passwordFocus = FocusNode();
  var isTypingPassword = false.obs;
  var passwordVisible = true.obs;
  var password = ''.obs;

  @override
  void onInit() {
    _checkLoginAndNavigate();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    displayNameController = TextEditingController();
    initFocusListeners();
    passwordController.addListener(
      () => password.value = passwordController.text,
    );

    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
    super.onClose();
  }

  void initFocusListeners() {
    passwordFocus.addListener(() {
      isTypingPassword.value = passwordFocus.hasFocus;
    });
  }

  void updatePassword(String value) {
    password.value = value;
  }

  void unHide() {
    passwordVisible.value = !passwordVisible.value;
    update();
  }

  void initData() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    displayNameController.clear();
  }

  // ---------- UI Helpers ----------
  void _showLoadingDialog(String message) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showResultDialog({
    required bool success,
    required String message,
    Duration duration = const Duration(seconds: 1),
  }) async {
    if (Get.isDialogOpen ?? false) Get.back(); // Tutup loading dialog

    // Tampilkan dialog hasil
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black12,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: success ? Colors.green : Colors.red,
                  child: Icon(
                    success ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Delay kemudian tutup dialog
    await Future.delayed(duration);
    if (Get.isDialogOpen ?? false) Get.back();
  }
  // --------- USER CHECK LOGIN --------

  Future<void> _checkLoginAndNavigate() async {
    log("Check Dijalankan!");
    await Future.delayed(const Duration(seconds: 3));

    final accessToken = await box.read('access_token');
    log(" Akses token = $accessToken");

    if (accessToken != null) {
      Get.offNamed('/home');
    } else {
      Get.offNamed('/login');
    }
  }

  // ------------- FORGOT AND RESET PASSWORD ----------------
  final isLoading = false.obs;
  Future<void> sendForgotPasswordEmail(String email) async {
    Get.log('📩 Forgot password process started for: $email');
    isLoading.value = true;

    try {
      Get.log('⏳ Calling _authService.sendForgotPasswordEmail…');
      await _authService.sendForgotPasswordEmail(email);

      Get.log('✅ Forgot password email sent to: $email');
      Get.snackbar('Success', 'Check your email for reset password link.');
    } catch (e) {
      Get.log('❌ Failed to send forgot password email: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
      Get.log('📩 Forgot password process finished');
    }
  }

  Future<void> resetPassword(String newPassword) async {
    isLoading.value = true;
    try {
      await _authService.updatePassword(newPassword);
      Get.snackbar('Success', 'Password updated. Please login again.');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- LOGIN SERVICE ----------
  Future<void> loginService(String email, String password) async {
    _showLoadingDialog("Logging in..");

    try {
      final loginResp = await _authService.login(email, password);

      // Ambil session
      final session = loginResp['session'];
      if (session == null) {
        throw Exception('Session tidak ditemukan di response');
      }

      final accessToken = session['access_token'];
      final refreshToken = session['refresh_token'];

      if (accessToken == null || refreshToken == null) {
        throw Exception('Token tidak ditemukan di session');
      }

      await box.write('access_token', accessToken);
      await box.write('refresh_token', refreshToken);

      // Simpan detail user yg login
      final userJson = loginResp['user'];
      if (userJson != null) {
        userModel = UserModel.fromJson(userJson);
        log('[LoginService] 💾 User login: ${userModel!.email}');
        await box.write('current_user', userModel!.toJsonLogin());
      } else {
        throw Exception('Data user tidak ditemukan pada response');
      }

      await _showResultDialog(
        success: true,
        message: 'Login Successful!',
        duration: const Duration(milliseconds: 1500),
      );

      log('[LoginService] 🚀 Navigating to /home');
      Get.offAllNamed(Routes.HOME);
    } catch (e, stacktrace) {
      log('[LoginService] ❌ Error: ${e.toString()}');
      log('[LoginService] 🪵 Stacktrace: $stacktrace');

      await _showResultDialog(
        success: false,
        message: e.toString(),
        duration: const Duration(seconds: 2),
      );
    } finally {
      log('[LoginService] 🛑 Finished');
    }
  }

  // --- LOGOUT SERVICE ---
  Future<void> logoutService() async {
    log('[LogoutService] ✅ Started');

    try {
      log('[LogoutService] 🗑️ Menghapus token dari storage...');
      await box.remove('access_token');
      await box.remove('refresh_token');
      await box.remove('email');
      await Get.delete<HomeController>(force: true);

      log('[LogoutService] ✅ Token & email dihapus');

      log('[LogoutService] 🔗 Memanggil API logout (jika ada)...');
      try {
        // Optional: jika backend butuh notif logout
        await _authService.logout();
        log('[LogoutService] 🔗 Logout API sukses');
      } catch (apiError) {
        log('[LogoutService] ⚠️ Logout API error: $apiError');
        // Tidak fatal — kita tetap lanjut hapus token lokal
      }

      await _showResultDialog(
        success: true,
        message: 'Logout Successful!',
        duration: const Duration(milliseconds: 1500),
      );
      initData();

      log('[LogoutService] 🚀 Navigating to /login');
      Get.offAllNamed('/login');
    } catch (e, stacktrace) {
      log('[LogoutService] ❌ Error: ${e.toString()}');
      log('[LogoutService] 🪵 Stacktrace: $stacktrace');

      await _showResultDialog(
        success: false,
        message: e.toString(),
        duration: const Duration(seconds: 2),
      );
    } finally {
      log('[LogoutService] 🛑 Finished');
    }
  }

  // ---------- REGISTER SERVICE ------------
  Future<void> registerService(UserModel user) async {
    try {
      log('[RegisterService] ✅ Started');
      log('[UserModel.toJson] ${user.toJsonRegister()}');

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await _authService.register(user);

      log('[RegisterService] 🎯 Register API response: $response');

      if (Get.isDialogOpen ?? false) {
        log('[RegisterService] 🔙 Closing loading dialog');
        Get.back();
      }

      final registeredUser = UserModel.fromJson(response['user']);
      log('[RegisterService] 👤 registeredUser: $registeredUser');
      log('[RegisterService] 👤 id: ${registeredUser.id}');
      log('[RegisterService] 👤 email: ${registeredUser.email}');
      log('[RegisterService] 👤 displayName: ${registeredUser.displayName}');
      log('[RegisterService] 👤 createdAt: ${registeredUser.createdAt}');

      Get.snackbar(
        "Registrasi Berhasil",
        "Silakan login menggunakan akun Anda",
      );
      initData();
      Get.off(() => LoginView());
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      final errorMsg = e.toString().replaceAll('Exception: ', '');
      log('[RegisterService] ❌ Register error: $errorMsg');
      log('[RegisterService] 🧾 User data at error: ${user.toJsonRegister()}');

      Get.defaultDialog(title: "Error", middleText: errorMsg);

      rethrow;
    }
  }

  // ------------ UPDATE USER --------------
  Future<void> updateUserService() async {
    log('[UpdateUserService]  Started');

    if (userModel == null) {
      Get.snackbar("Error", "User belum login");
      return;
    }

    _showLoadingDialog("Updating profile..");

    try {
      final updatedData = {
        'email': emailController.text.trim(),
        'displayName': displayNameController.text.trim(),
      };

      log('[UpdateUserService] Payload: $updatedData');

      final updatedUser = await _authService.updateUser(
        userModel!.id!,
        updatedData,
      );

      log('[UpdateUserService] Update API response: $updatedUser');

      // Update lokal model
      userModel = UserModel.fromJson(updatedUser);

      // Simpan ke storage juga jika perlu
      await box.write('current_user', userModel!.toJsonLogin());

      await _showResultDialog(
        success: true,
        message: 'Profile updated!',
        duration: const Duration(milliseconds: 1500),
      );

      update(); // trigger update UI jika pakai GetBuilder
    } catch (e) {
      log('[UpdateUserService] Error: ${e.toString()}');
      await _showResultDialog(
        success: false,
        message: e.toString().replaceAll('Exception: ', ''),
        duration: const Duration(seconds: 2),
      );
    } finally {
      log('[UpdateUserService]  Finished');
    }
  }
}
