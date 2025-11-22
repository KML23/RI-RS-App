import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationController extends GetxController {
  // 0 = Reminder, 1 = List, 2 = Detail
  var viewState = 0.obs; 

  // Data Dummy (Sama seperti sebelumnya)
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
      "schedules": [{"time": "Pagi (08.00)", "taken": true}]
    },
    {
      "name": "Panadol 10mg",
      "schedules": [{"time": "Pagi (08.00)", "taken": true}]
    },
    {
      "name": "Vitamin 10mg",
      "schedules": [{"time": "Malam (20.00)", "taken": true}]
    },
  ];

  // --- Actions ---

  void markAsTaken() {
    // Masuk ke tampilan List
    viewState.value = 1; 
    
    if (Get.context != null) {
       ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Obat diminum"), backgroundColor: Colors.green),
      );
    }
  }

  void snoozeReminder() {
    // Masuk ke tampilan List
    viewState.value = 1;
  }

  void showDetail(String medicineName) {
    // Masuk ke tampilan Detail
    // (Bisa ditambahkan logika cek nama obat disini, tapi kita buat simpel dulu)
    viewState.value = 2; 
  }

  void backToList() {
    // Kembali ke tampilan List
    viewState.value = 1;
  }
  
  void backToReminder() {
    // Reset ke awal (opsional untuk debug)
    viewState.value = 0;
  }
}