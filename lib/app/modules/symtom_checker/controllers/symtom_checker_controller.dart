import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SymtomCheckerController extends GetxController {
  final searchController = TextEditingController();
  
  var isSearching = false.obs;
  var searchResults = <Map<String, dynamic>>[].obs;

    var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // Data Master: Kategori beserta Penyakit di dalamnya
  var categoriesData = <Map<String, dynamic>>[
    {
      "category": "Kondisi Kulit (ruam, memar, luka)",
      "isExpanded": false, // Untuk menampilkan/menyembunyikan anak
      "isSelected": false, // Status checkbox induk
      "symptoms": [
        {
          "id": 1,
          "name": "Ruam Kulit",
          "desc_normal": "Kemerahan ringan.", 
          "desc_danger": "Bernanah/bengkak.",
          "isSelected": false
        },
        {
          "id": 3,
          "name": "Luka Terbuka",
          "desc_normal": "Luka kecil.", 
          "desc_danger": "Pendarahan hebat.",
          "isSelected": false
        },
      ]
    },
    {
      "category": "Demam dan Pernapasan",
      "isExpanded": false,
      "isSelected": false,
      "symptoms": [
        {
          "id": 2,
          "name": "Demam Tinggi",
          "desc_normal": "Suhu <38°C.", 
          "desc_danger": "Kejang.",
          "isSelected": false
        },
        {
          "id": 5,
          "name": "Asma / Sesak",
          "desc_normal": "Napas berat.", 
          "desc_danger": "Bibir biru.",
          "isSelected": false
        },
      ]
    },
    {
      "category": "Masalah Pencernaan",
      "isExpanded": false,
      "isSelected": false,
      "symptoms": [
        {
          "id": 4,
          "name": "Diare",
          "desc_normal": "BAB lembek.", 
          "desc_danger": "Mata cekung.",
          "isSelected": false
        },
      ]
    },
  ].obs;

  // Fungsi Search
  void onSearchChanged(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
    } else {
      isSearching.value = true;
      List<Map<String, dynamic>> tempResults = [];
      
      // Loop semua kategori dan cari penyakit yang namanya cocok
      for (var cat in categoriesData) {
        var symptoms = cat['symptoms'] as List;
        for (var sym in symptoms) {
          if (sym['name'].toString().toLowerCase().contains(query.toLowerCase())) {
            Map<String, dynamic> found = Map.from(sym);
            found['category_name'] = cat['category'];
            tempResults.add(found);
          }
        }
      }
      searchResults.assignAll(tempResults);
    }
  }

  // Fungsi Toggle Checkbox Induk (Kategori)
  void toggleCategory(int catIndex, bool? val) {
    bool newValue = val ?? false;
    
    var cat = categoriesData[catIndex];
    cat['isSelected'] = newValue;
    cat['isExpanded'] = newValue; 
    
    for (var sym in cat['symptoms']) {
      sym['isSelected'] = newValue;
    }
    categoriesData.refresh();
  }

  // Fungsi Toggle Checkbox Anak (Penyakit)
  void toggleSymptom(int catIndex, int symIndex, bool? val) {
    bool newValue = val ?? false;
    
    categoriesData[catIndex]['symptoms'][symIndex]['isSelected'] = newValue;
    categoriesData.refresh();
  }

  // Navigasi ke Detail (Logic sama seperti sebelumnya)
  void goToDetail(Map<String, dynamic> data) {
    Get.toNamed('/symptom-detail', arguments: data); 
  }

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

  
