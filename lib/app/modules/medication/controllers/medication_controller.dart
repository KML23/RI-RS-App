import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationController extends GetxController {
  var viewState = 0.obs;

  
  final nameC = TextEditingController();
  final doseC = TextEditingController();
  var selectedTime = TimeOfDay.now().obs; 

  
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

  

  
  void goToAddReminder() {
    
    nameC.clear();
    doseC.clear();
    selectedTime.value = TimeOfDay.now();
    
    viewState.value = 3; 
  }

  
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, 
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

  
  void saveManualReminder() {
    if (nameC.text.isNotEmpty && doseC.text.isNotEmpty) {
      
      Get.snackbar(
        "Berhasil",
        "Pengingat ${nameC.text} berhasil ditambahkan",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
      
      
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