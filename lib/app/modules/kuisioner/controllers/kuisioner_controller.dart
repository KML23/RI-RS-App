import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../appointment/controllers/appointment_controller.dart';

class KuisionerController extends GetxController {
  // Input Controllers
  final complaintC = TextEditingController();
  final sideEffectC = TextEditingController();

  // Reactive Variables
  var painScale = 0.0.obs; // Skala Nyeri 0-10
  var isLoading = false.obs; // Untuk loading button

  // Fungsi Submit Jawaban
  void submitKuisioner() async {
    // Validasi sederhana
    if (complaintC.text.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Mohon isi keluhan utama Anda",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }

    // Simulasi Loading agar terasa "Real"
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // --- LOGIKA UTAMA: KOMUNIKASI ANTAR CONTROLLER ---
    // Mencari AppointmentController yang sedang aktif di memori
    // Pastikan AppointmentController SUDAH di-put (diakses) sebelumnya
    if (Get.isRegistered<AppointmentController>()) {
      Get.find<AppointmentController>().markKuisionerAsDone();
    } else {
      // Fallback jika user membuka kuisioner langsung tanpa lewat appointment (jarang terjadi)
      print("AppointmentController belum di-load");
    }

    // Feedback Sukses
    Get.snackbar(
      "Berhasil",
      "Data kuisioner telah dikirim ke Dokter",
      backgroundColor: const Color(0xFF28A745), // Hijau Sukses
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );

    // Kembali ke halaman sebelumnya (AppointmentView)
    Get.back();
  }

  @override
  void onClose() {
    complaintC.dispose();
    sideEffectC.dispose();
    super.onClose();
  }
}
