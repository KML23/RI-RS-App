import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controller untuk input text
  final emailC = TextEditingController();
  final passC = TextEditingController();

  // Reactive variable untuk hide/show password
  // Default true (tersembunyi)
  var isPasswordHidden = true.obs;

  // Fungsi untuk mengubah status hide/show
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi Login (Simulasi)
  void login() {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      Get.snackbar("Sukses", "Sedang mencoba masuk...",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      // Lakukan logika API login disini
    } else {
      Get.snackbar("Error", "Harap isi semua kolom",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // Fungsi Navigasi ke Halaman Register
  void goToRegister() {
    // Pastikan route '/register' sudah didaftarkan di AppPages
    Get.toNamed('/register'); 
  }

  @override
  void onClose() {
    // Membersihkan controller agar tidak memory leak
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}