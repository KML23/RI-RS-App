import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

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

  // Loading State
  var isLoading = false.obs;

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
      // Di sini Anda bisa menambahkan validasi format RM jika perlu
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

  // Finalisasi Registrasi ke Firebase
  Future<void> submitRegistration() async {
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

    try {
      isLoading.value = true;

      // 1. Format Email Buatan (RM + domain dummy)
      // Karena Firebase Auth butuh email, kita ubah RM jadi format email
      // Contoh: 12345 -> 12345@rs-app.com
      String fakeEmail = "${rmC.text.trim()}@rs-app.com";

      // 2. Buat User di Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: passC.text,
      );

      // 3. Simpan Data Profil ke Cloud Firestore
      // Kita simpan di collection 'users' dengan ID dokumen = UID dari Auth
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'rm': rmC.text.trim(),
        'dob': dobC.text,
        'name': "Pasien ${rmC.text.trim()}", // Default name, bisa dikembangkan formnya
        'role': 'patient',
        'created_at': DateTime.now().toIso8601String(),
      });

      Get.snackbar("Sukses", "Akun berhasil dibuat!",
          backgroundColor: Colors.green, colorText: Colors.white);
      
      // Arahkan ke Halaman Login agar user login ulang (atau bisa langsung ke Home)
      Get.offAllNamed('/login');

    } on FirebaseAuthException catch (e) {
      String errorMessage = "Terjadi kesalahan";
      if (e.code == 'email-already-in-use') {
        errorMessage = "Nomor Rekam Medis ini sudah terdaftar.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password terlalu lemah. Gunakan minimal 6 karakter.";
      }
      Get.snackbar("Gagal Registrasi", errorMessage,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
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