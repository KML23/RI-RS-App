import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <--- PENTING: Untuk SystemChannels
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  var currentStep = 1.obs;
  
  final rmC = TextEditingController();
  final dobC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();
  
  var isPassHidden = true.obs;
  var isConfirmHidden = true.obs;
  var isTermsAccepted = false.obs;
  var isLoading = false.obs;

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
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

  // --- FUNGSI REGISTRASI (ANTI CRASH VERSION) ---
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

      // 1. Buat Email Format dari RM
      String dummyEmail = "${rmC.text.trim()}@rs-app.com";

      // 2. Buat Akun di Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: dummyEmail,
        password: passC.text,
      );

      // 3. Simpan Detail Profil ke Cloud Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'rm': rmC.text.trim(),
        'dob': dobC.text,
        'name': "Pasien Baru", // Default, nanti bisa diubah di profil
        'created_at': DateTime.now().toIso8601String(),
      });

      // 4. Sukses
      Get.snackbar("Sukses", "Akun berhasil dibuat! Silakan Login.", backgroundColor: Colors.green, colorText: Colors.white);
      
      // --- UPDATE PENTING: MENCEGAH CRASH KEYBOARD ---
      
      // Cara 1: Unfocus standar
      FocusManager.instance.primaryFocus?.unfocus();
      
      // Cara 2: Paksa sistem Android menutup input channel (LEBIH KUAT)
      // Ini memastikan keyboard benar-benar mati sebelum halaman dihancurkan
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      
      // Beri waktu napas 1.5 detik agar animasi transisi keyboard selesai total
      // Jangan dikurangi durasinya, ini kunci kestabilan emulator
      await Future.delayed(const Duration(milliseconds: 1500)); 

      // 5. Logout & Pindah Halaman
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
  }
}