import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  // Ubah nama variable biar jelas (ini input RM, bukan Email biasa)
  final rmInputC = TextEditingController(); 
  final passC = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // --- FUNGSI LOGIN ASLI ---
  void login() async {
    if (rmInputC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        isLoading.value = true;

        // 1. Trik: Konversi RM ke Email Dummy yg sama dengan Register
        String dummyEmail = "${rmInputC.text.trim()}@rs-app.com";

        // 2. Login ke Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: dummyEmail,
          password: passC.text,
        );

        Get.snackbar("Sukses", "Berhasil masuk...", backgroundColor: Colors.green, colorText: Colors.white);
        
        // 3. Pindah ke Home
        Get.offAllNamed(Routes.HOME);

      } on FirebaseAuthException catch (e) {
        String message = "Login Gagal";
        if (e.code == 'user-not-found') message = "Nomor RM tidak ditemukan";
        if (e.code == 'wrong-password') message = "Password salah";
        
        Get.snackbar("Gagal", message, backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Harap isi Nomor RM dan Password", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER); 
  }

  @override
  void onClose() {
    rmInputC.dispose();
    passC.dispose();
    super.onClose();
  }
}