import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Jangan lupa: flutter pub add intl

class RegisterController extends GetxController {
  // --- STATE VARIABLES ---
  var currentStep = 1.obs; // 1 untuk Tahap 1, 2 untuk Tahap 2
  
  // Tahap 1 Inputs
  final rmC = TextEditingController(); // Rekam Medis
  final dobC = TextEditingController(); // Tanggal Lahir

  // Tahap 2 Inputs
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();
  
  // Visibility & Checkbox
  var isPassHidden = true.obs;
  var isConfirmHidden = true.obs;
  var isTermsAccepted = false.obs;

  // --- ACTIONS ---

  // Fungsi pilih tanggal
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Format tanggal jadi DD / MM / YYYY
      dobC.text = DateFormat('dd / MM / yyyy').format(picked);
    }
  }

  // Pindah dari Tahap 1 ke Tahap 2 (Verifikasi Data)
  void verifyData() {
    if (rmC.text.isNotEmpty && dobC.text.isNotEmpty) {
      // Simulasi cek ke server...
      // Jika valid:
      currentStep.value = 2; 
    } else {
      Get.snackbar("Error", "Harap lengkapi data diri Anda", 
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Tombol Kembali di Header
  void backButton() {
    if (currentStep.value == 2) {
      currentStep.value = 1; // Mundur ke tahap 1
    } else {
      Get.back(); // Kembali ke halaman Login/sebelumnya
    }
  }

  // Finalisasi Registrasi
  void submitRegistration() {
    if (!isTermsAccepted.value) {
      Get.snackbar("Info", "Anda harus menyetujui syarat & ketentuan",
        backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (passC.text != confirmPassC.text) {
       Get.snackbar("Error", "Password konfirmasi tidak sama",
        backgroundColor: Colors.red, colorText: Colors.white);
       return;
    }

    // Logic simpan ke database...
    Get.snackbar("Sukses", "Akun berhasil dibuat!",
        backgroundColor: Colors.green, colorText: Colors.white);
    
    // Arahkan ke Dashboard/Login
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    rmC.dispose();
    dobC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    super.onClose();
  }
}