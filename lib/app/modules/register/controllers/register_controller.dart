import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class RegisterController extends GetxController {
  var currentStep = 1.obs;
  
  final rmC = TextEditingController();
  final dobC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();
  
  var isPassHidden = true.obs;
  var isConfirmHidden = true.obs;
  var isTermsAccepted = false.obs;
  var isLoading = false.obs; // Tambahan loading state

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990), // Default lebih lama biar enak
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobC.text = DateFormat('dd / MM / yyyy').format(picked);
    }
  }

  void verifyData() {
    if (rmC.text.isNotEmpty && dobC.text.isNotEmpty) {
      currentStep.value = 2; 
    } else {
      Get.snackbar("Error", "Harap lengkapi data diri Anda", 
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void backButton() {
    if (currentStep.value == 2) {
      currentStep.value = 1;
    } else {
      Get.back();
    }
  }

  // --- FUNGSI REGISTRASI ASLI ---
  void submitRegistration() async {
    if (!isTermsAccepted.value) {
      Get.snackbar("Info", "Anda harus menyetujui syarat & ketentuan", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (passC.text != confirmPassC.text) {
       Get.snackbar("Error", "Password konfirmasi tidak sama", backgroundColor: Colors.red, colorText: Colors.white);
       return;
    }

    try {
      isLoading.value = true;

      // 1. Trik: Ubah RM jadi Email format (karena Firebase wajib email)
      String dummyEmail = "${rmC.text.trim()}@rs-app.com";

      // 2. Buat Akun di Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: dummyEmail,
        password: passC.text,
      );

      // 3. Simpan Detail Profil ke Cloud Firestore
      // Kita set nama default dulu, nanti bisa diedit
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'rm': rmC.text.trim(),
        'dob': dobC.text,
        'name': "Pasien Baru", // Default name
        'created_at': DateTime.now().toIso8601String(),
      });

      // 4. Sukses
      Get.snackbar("Sukses", "Akun berhasil dibuat! Silakan Login.", backgroundColor: Colors.green, colorText: Colors.white);
      
      // Logout otomatis biar user login ulang (biar flow aman)
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');

    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";
      if (e.code == 'weak-password') message = "Password terlalu lemah (min 6 karakter)";
      if (e.code == 'email-already-in-use') message = "Nomor RM ini sudah terdaftar";
      
      Get.snackbar("Gagal", message, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
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