import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  // Data Dummy User
  final userName = "Bapak Sandy";
  final userRM = "20221037031147";

  // Note: List 'carePlan' SUDAH DIHAPUS agar tampilan Home lebih bersih.

  // Daftar Menu Utama (Diupdate)
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
      // MENU BARU: Menggantikan List Rencana Perawatan
      "title": "Panduan", 
      "icon": Icons.menu_book_outlined, // Icon buku panduan
      "color": const Color(0xFFFFA600), 
      "route": Routes.EDUCATION, 
    },
  ];

  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}