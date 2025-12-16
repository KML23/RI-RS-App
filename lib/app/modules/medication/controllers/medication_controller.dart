import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationController extends GetxController {
  // STATUS TAMPILAN
  // 0 = Reminder (Hitam)
  // 1 = List Jadwal (Putih)
  // 2 = Detail Obat
  // 3 = Tambah Pengingat (BARU)
  var viewState = 0.obs;

  // --- FORM INPUT VARIABLES (BARU) ---
  final nameC = TextEditingController();
  final doseC = TextEditingController();
  var selectedTime = TimeOfDay.now().obs; // Default waktu sekarang

  // DATA DUMMY
  final List<Map<String, dynamic>> medicationList = [
    {
      "name": "PARACETAMOL 500mg",
      "schedules": [
        {"time": "Pagi (08.00)", "taken": true},
        {"time": "Siang (14.00)", "taken": true},
        {"time": "Malam (20.00)", "taken": false},
      ]
    },
    {
      "name": "Amlodipin 10mg",
      "schedules": [
        {"time": "Pagi (08.00)", "taken": true}
      ]
    },
    {
      "name": "Panadol 10mg",
      "schedules": [
        {"time": "Pagi (08.00)", "taken": true}
      ]
    },
    {
      "name": "Vitamin 10mg",
      "schedules": [
        {"time": "Malam (20.00)", "taken": true}
      ]
    },
  ];

  // --- ACTIONS ---

  // 1. Masuk ke Halaman Tambah (State 3)
  void goToAddReminder() {
    // Reset form agar kosong saat dibuka
    nameC.clear();
    doseC.clear();
    selectedTime.value = TimeOfDay.now();
    
    viewState.value = 3; 
  }

  // 2. Fungsi Pilih Jam (TimePicker)
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Header hitam
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  // 3. Simpan Pengingat Baru
  void saveManualReminder() {
    if (nameC.text.isNotEmpty && doseC.text.isNotEmpty) {
      // Tampilkan notifikasi sukses
      Get.snackbar(
        "Berhasil",
        "Pengingat ${nameC.text} berhasil ditambahkan",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
      
      // Kembali ke tampilan List Jadwal
      viewState.value = 1; 
    } else {
      Get.snackbar(
        "Gagal",
        "Mohon lengkapi Nama Obat dan Dosis",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
    }
  }

  // --- NAVIGASI STANDAR ---

  void markAsTaken() {
    viewState.value = 1;
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Obat diminum"), backgroundColor: Colors.green),
      );
    }
  }

  void snoozeReminder() {
    viewState.value = 1;
  }

  void showDetail(String medicineName) {
    viewState.value = 2;
  }

  void backToList() {
    // Fungsi tombol 'Kembali'
    // Jika dari Detail (2) atau Tambah (3), kembali ke List (1)
    viewState.value = 1;
  }

  void backToReminder() {
    viewState.value = 0;
  }
  
  @override
  void onClose() {
    nameC.dispose();
    doseC.dispose();
    super.onClose();
  }
}