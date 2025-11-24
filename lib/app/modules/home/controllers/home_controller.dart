import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  // Data Dummy User
  final userName = "Bapak Manto";
  final userRM = "20221037031147";

  // Daftar Menu Utama
  // Kita simpan di sini agar mudah diedit/ditambah
  final List<Map<String, dynamic>> menus = [
    {
      "title": "Cek Gejala",
      "icon": Icons.medical_services_outlined,
      "color": Color(0xFFFF6B6B), // Merah soft
      "route": Routes.SYMTOM_CHECKER,
    },
    {
      "title": "Jadwal Obat",
      "icon": Icons.medication_liquid_outlined,
      "color": Color(0xFF4ECDC4), // Tosca
      "route": Routes.MEDICATION,
    },
    {
      "title": "Janji Temu",
      "icon": Icons.calendar_month_outlined,
      "color": Color(0xFF1A535C), // Biru tua
      "route": Routes.APPOINTMENT,
    },
    {
      "title": "Konsultasi",
      "icon": Icons.chat_bubble_outline,
      "color": Color(0xFF6A0572), // Ungu
      "route": Routes.CHAT,
    },
    {
      "title": "Edukasi",
      "icon": Icons.menu_book_outlined,
      "color": Color(0xFFFFA600), // Oranye
      "route": Routes.EDUCATION,
    },
  ];

  // Navigasi ke halaman Login/Register (Untuk demo logout)
  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
