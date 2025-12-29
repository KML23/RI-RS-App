import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  // Data Dummy User (Nanti bisa ambil dari Firestore)
  final userProfile = {
    "name": "Budi Santoso",
    "rm_number": "RM-2023-8899",
    "email": "budisantoso@gmail.com",
    "phone": "0812-3456-7890",
    "age": "68 Tahun",
    "image": "https://i.pravatar.cc/150?img=11" // Foto profil dummy
  }.obs;

  // Fungsi Logout dengan Konfirmasi Aman
  void logout() {
    Get.defaultDialog(
      title: "Konfirmasi",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Apakah Anda yakin ingin keluar dari aplikasi?",
      radius: 20,
      textCancel: "Batal",
      textConfirm: "Ya, Keluar",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.black87,
      onConfirm: () async {
        await FirebaseAuth.instance.signOut();
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}