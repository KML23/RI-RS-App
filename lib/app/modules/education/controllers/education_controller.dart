import 'package:get/get.dart';

class EducationController extends GetxController {
  // Simulasi Data Panduan (Nanti bisa dari API/Firebase)
  final List<Map<String, dynamic>> educationList = [
    {
      "id": 1,
      "title": "Perawatan Luka Pasca-Operasi",
      "category": "Luka Bedah",
      "duration": "5 Menit",
      "thumbnail_color": 0xFF4FACFE, // Warna Hex Dummy
      "video_url": "https://www.youtube.com/watch?v=1PWrYGO2v9U", // Simulasi
      "steps": [
        {
          "step_no": 1,
          "title": "Cuci Tangan",
          "description": "Cuci tangan dengan sabun dan air mengalir selama minimal 20 detik sebelum menyentuh area luka.",
          "image_asset": "assets/wash_hands.png" 
        },
        {
          "step_no": 2,
          "title": "Buka Perban Perlahan",
          "description": "Basahi plester dengan sedikit air bersih agar mudah dilepas tanpa rasa sakit.",
          "image_asset": "assets/open_bandage.png"
        },
        {
          "step_no": 3,
          "title": "Bersihkan Luka",
          "description": "Usap perlahan dengan kassa steril yang dibasahi cairan infus (NaCl). Jangan digosok keras.",
          "image_asset": "assets/clean_wound.png"
        },
      ]
    },
    {
      "id": 2,
      "title": "Cara Minum Obat yang Benar",
      "category": "Edukasi Obat",
      "duration": "3 Menit",
      "thumbnail_color": 0xFFFFA600,
      "steps": []
    },
    {
      "id": 3,
      "title": "Pola Makan Pemulihan",
      "category": "Nutrisi",
      "duration": "7 Menit",
      "thumbnail_color": 0xFF00C853,
      "steps": []
    },
  ].obs;

  // Variable untuk handle detail view
  var isDetailOpen = false.obs;
  var selectedGuide = <String, dynamic>{}.obs;

  void openDetail(Map<String, dynamic> guide) {
    selectedGuide.value = guide;
    isDetailOpen.value = true;
  }

  void closeDetail() {
    isDetailOpen.value = false;
    selectedGuide.clear();
  }
}