import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationController extends GetxController {
  // Setup Firebase
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // State Variables
  var viewState = 1.obs; // 0: Reminder, 1: List, 2: Detail, 3: Add
  var isLoading = true.obs;
  
  // Input Controllers (Untuk Form Tambah)
  final nameC = TextEditingController();
  final doseC = TextEditingController();
  var selectedTime = TimeOfDay.now().obs;

  // Data Real-Time dari Firestore
  var medicationList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Langsung pasang "Telinga" (Stream) ke Database saat controller hidup
    bindMedicationStream();
  }

  // --- 1. MEMBACA DATA (READ - STREAM) ---
  void bindMedicationStream() {
    User? user = auth.currentUser;
    if (user != null) {
      // Mendengarkan perubahan di koleksi 'medications' milik user
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('medications')
          .snapshots()
          .listen((snapshot) {
        
        // Setiap ada perubahan di database, kode ini jalan otomatis
        var processedList = <Map<String, dynamic>>[];

        for (var doc in snapshot.docs) {
          var data = doc.data();
          // Kita format agar sesuai dengan UI yang sudah ada
          processedList.add({
            "id": doc.id, // Penting untuk hapus/edit nanti
            "name": "${data['name']} ${data['dose']}",
            "raw_name": data['name'],
            "dose": data['dose'],
            // Mapping array jam dari Firestore ke format UI
            "schedules": (data['times'] as List<dynamic>).map((t) => {
              "time": t.toString(),
              "taken": false // Default false dulu (nanti bisa dikembangkan)
            }).toList()
          });
        }
        
        medicationList.assignAll(processedList);
        isLoading.value = false;
      }, onError: (e) {
        print("Error stream obat: $e");
        isLoading.value = false;
      });
    } else {
      isLoading.value = false;
    }
  }

  // --- 2. MENAMBAH DATA (CREATE) ---
  void saveManualReminder() async {
    if (nameC.text.isNotEmpty && doseC.text.isNotEmpty) {
      User? user = auth.currentUser;
      if (user == null) return;

      try {
        isLoading.value = true;
        
        // Format jam "08:00"
        String formattedTime = "${selectedTime.value.hour.toString().padLeft(2, '0')}.${selectedTime.value.minute.toString().padLeft(2, '0')}";

        // Simpan ke Firestore
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('medications')
            .add({
          "name": nameC.text,
          "dose": doseC.text,
          "times": [formattedTime], // Sementara 1 jam dulu (array)
          "created_at": FieldValue.serverTimestamp(),
          "is_active": true
        });

        // Reset Form & UI
        nameC.clear();
        doseC.clear();
        viewState.value = 1; // Kembali ke list
        
        Get.snackbar("Berhasil", "Jadwal obat tersimpan di Cloud!", backgroundColor: Colors.green, colorText: Colors.white);

      } catch (e) {
        Get.snackbar("Error", "Gagal menyimpan: $e", backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Gagal", "Mohon lengkapi data", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // --- 3. MENGHAPUS DATA (DELETE) ---
  // Fungsi ini bisa dipanggil nanti misal di detail obat
  void deleteMedication(String docId) async {
    User? user = auth.currentUser;
    if (user == null) return;

    Get.defaultDialog(
      title: "Hapus Jadwal?",
      middleText: "Data akan hilang permanen.",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('medications')
            .doc(docId)
            .delete();
        Get.back(); // Tutup dialog
        Get.back(); // Tutup halaman detail (jika sedang di detail)
        viewState.value = 1;
        Get.snackbar("Dihapus", "Jadwal obat telah dihapus", backgroundColor: Colors.orange, colorText: Colors.white);
      }
    );
  }

  // --- NAVIGASI & UTILS ---
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
    );
    if (picked != null) selectedTime.value = picked;
  }

  void markAsTaken() {
    viewState.value = 1;
    Get.snackbar("Hebat!", "Obat tercatat sudah diminum", backgroundColor: Colors.green, colorText: Colors.white);
  }

  void snoozeReminder() {
    viewState.value = 1;
  }

  // Saat detail, kita bisa simpan ID dokumen yang sedang dilihat
  var currentDocId = "".obs;
  
  void showDetail(String medicineName, {String? docId}) {
    if (docId != null) currentDocId.value = docId;
    viewState.value = 2;
  }

  void backToList() => viewState.value = 1;

  @override
  void onClose() {
    nameC.dispose();
    doseC.dispose();
    super.onClose();
  }
}