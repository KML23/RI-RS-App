import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  // Data User (Sekarang Reactive .obs)
  var userName = "Memuat...".obs;
  var userRM = "...".obs;

  // Daftar Menu Utama
  final List<Map<String, dynamic>> menus = [
    {
      "title": "Cek Gejala",
      "icon": Icons.medical_services_outlined,
      "color": const Color(0xFFFF6B6B), 
      "route": Routes.SYMTOM_CHECKER,
    },
    {
      "title": "Jadwal Obat",
      "icon": Icons.medication_liquid_outlined,
      "color": const Color(0xFF4ECDC4), 
      "route": Routes.MEDICATION,
    },
    {
      "title": "Janji Temu",
      "icon": Icons.calendar_month_outlined,
      "color": const Color(0xFF1A535C), 
      "route": Routes.APPOINTMENT,
    },
    {
      "title": "Konsultasi",
      "icon": Icons.chat_bubble_outline,
      "color": const Color(0xFF6A0572), 
      "route": Routes.CHAT,
    },
    {
      "title": "Panduan", 
      "icon": Icons.menu_book_outlined,
      "color": const Color(0xFFFFA600), 
      "route": Routes.EDUCATION, 
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi ambil data user saat Controller dibuat
    fetchUserProfile();
  }

  // Fungsi ambil data profil dari Firestore
  void fetchUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          userName.value = data['name'] ?? "User";
          userRM.value = data['rm'] ?? "-";
        }
      } catch (e) {
        print("Gagal ambil data user: $e");
        userName.value = "User (Offline)";
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}