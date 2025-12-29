import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  // 1. Ganti 'final' menjadi 'late' agar bisa di-init ulang
  late TextEditingController rmInputC;
  late TextEditingController passC;

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 2. Inisialisasi di sini. Ini MENJAMIN controller selalu "segar" & "baru"
    // setiap kali halaman Login dibuka.
    rmInputC = TextEditingController();
    passC = TextEditingController();
  }

  @override
  void onClose() {
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    if (rmInputC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        isLoading.value = true;

        String dummyEmail = "${rmInputC.text.trim()}@rs-app.com";

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: dummyEmail,
          password: passC.text,
        );

        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);

        Get.snackbar(
          "Sukses", 
          "Berhasil masuk...", 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );

      } on FirebaseAuthException catch (e) {
        isLoading.value = false; 
        
        String message = "Login Gagal";
        if (e.code == 'user-not-found') message = "Nomor RM tidak ditemukan";
        if (e.code == 'wrong-password') message = "Password salah";
        if (e.code == 'invalid-credential') message = "Data login salah";
        
        Get.snackbar("Gagal", message, backgroundColor: Colors.red, colorText: Colors.white);
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar("Error", "Harap isi Nomor RM dan Password", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER); 
  }
}