import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SymtomCheckerController extends GetxController {
  // 1. VARIABLE UI
  final searchController = TextEditingController();
  var isSearching = false.obs;
  var selectedCategoryIndex = 0.obs; // Untuk Tab Kategori
  
  // 2. VARIABLE KAMERA
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // 3. DATA MASTER (Dipercantik dengan Icon & Warna)
  var categoriesData = <Map<String, dynamic>>[
    {
      "category": "Kulit",
      "icon": Icons.child_care,
      "color": 0xFFFF6B6B, // Merah Soft
      "symptoms": [
        {
          "id": 1,
          "name": "Ruam / Bintik",
          "desc_normal": "Kemerahan ringan tanpa demam.", 
          "desc_danger": "Bernanah, bengkak, atau menyebar cepat.",
          "icon": Icons.grain,
          
          "normal_signs": ["Bintik merah kecil tidak menyebar", "Anak tidak demam", "Tidak gatal berlebihan"],
          "normal_actions": ["Jaga kebersihan kulit", "Gunakan lotion bayi aman", "Pantau 24 jam"],
          
          "danger_signs": ["Disertai demam tinggi (>38°C)", "Bintik bernanah/cairan", "Menyebar luas cepat"],
          "danger_actions": ["Hubungi Tim Perawat", "Kirim foto evaluasi", "Bawa ke faskes jika memburuk"]
        },
        {
          "id": 2,
          "name": "Luka Terbuka",
          "desc_normal": "Luka gores kecil, darah berhenti.", 
          "desc_danger": "Luka dalam, pendarahan aktif.",
          "icon": Icons.cut,
          
          "normal_signs": ["Luka goresan kecil", "Darah berhenti < 5 menit", "Luka bersih"],
          "normal_actions": ["Bersihkan air mengalir", "Beri antiseptik", "Tutup plester"],
          
          "danger_signs": ["Luka menganga/dalam", "Darah tidak berhenti ditekan", "Kotor/berkarat"],
          "danger_actions": ["Tekan luka dengan kain bersih", "Segera ke UGD", "Mungkin butuh jahitan"]
        },
      ]
    },
    {
      "category": "Demam",
      "icon": Icons.thermostat,
      "color": 0xFFFFA600, // Oranye
      "symptoms": [
        {
          "id": 3,
          "name": "Demam Tinggi",
          "desc_normal": "Suhu < 38.5°C, anak aktif.", 
          "desc_danger": "Suhu > 40°C, kejang, lemas.",
          "icon": Icons.whatshot,
          
          "normal_signs": ["Suhu 37.5°C - 38.5°C", "Anak masih mau main", "Pipis lancar"],
          "normal_actions": ["Kompres hangat lipatan tubuh", "Banyak minum", "Observasi"],
          
          "danger_signs": ["Suhu >39°C (bayi) atau >40°C", "Anak kejang/mengigau", "Muntah terus"],
          "danger_actions": ["Beri penurun panas", "Segera ke RS", "Jangan selimuti tebal"]
        },
      ]
    },
    {
      "category": "Pencernaan",
      "icon": Icons.medical_services,
      "color": 0xFF4ECDC4, // Tosca
      "symptoms": [
        {
          "id": 4,
          "name": "Diare / Muntah",
          "desc_normal": "BAB lembek < 3x sehari.", 
          "desc_danger": "BAB cair terus, mata cekung.",
          "icon": Icons.water_drop,
          
          "normal_signs": ["BAB bubur 3-4x", "Anak tidak lemas", "Masih mau minum"],
          "normal_actions": ["Beri oralit/cairan", "Makan rendah serat", "Jaga kebersihan"],
          
          "danger_signs": ["BAB cair >10x", "Ada darah", "Mata cekung & lemas"],
          "danger_actions": ["Segera infus/ke RS", "Cek feses lab", "Waspada dehidrasi"]
        },
      ]
    },
     {
      "category": "Napas",
      "icon": Icons.air,
      "color": 0xFF2F80ED, // Biru
      "symptoms": [
        {
          "id": 5,
          "name": "Batuk / Sesak",
          "desc_normal": "Batuk sesekali, napas lega.", 
          "desc_danger": "Napas bunyi 'ngik', bibir biru.",
          "icon": Icons.cloud,
           // Data dummy sisa bisa dilengkapi...
          "normal_signs": [], "normal_actions": [], "danger_signs": [], "danger_actions": []
        },
      ]
    },
  ].obs;

  var searchResults = <Map<String, dynamic>>[].obs;

  // 4. LOGIC SEARCH
  void onSearchChanged(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
    } else {
      isSearching.value = true;
      List<Map<String, dynamic>> tempResults = [];
      for (var cat in categoriesData) {
        var symptoms = cat['symptoms'] as List;
        for (var sym in symptoms) {
          if (sym['name'].toString().toLowerCase().contains(query.toLowerCase())) {
            Map<String, dynamic> found = Map.from(sym);
            found['category_name'] = cat['category'];
            found['color'] = cat['color'];
            tempResults.add(found);
          }
        }
      }
      searchResults.assignAll(tempResults);
    }
  }

  // 5. LOGIC CHANGE CATEGORY
  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  // 6. KAMERA
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  void resetImage() {
    selectedImagePath.value = '';
  }
}