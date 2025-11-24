import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SymtomCheckerController extends GetxController {
  // 1. VARIABLE UNTUK SEARCH
  final searchController = TextEditingController();
  var isSearching = false.obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  
  // 2. VARIABLE UNTUK KAMERA/GALERI
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // 3. DATA MASTER (KATEGORI & PENYAKIT)
  var categoriesData = <Map<String, dynamic>>[
    {
      "category": "Kondisi Kulit (ruam, memar, luka)",
      "isExpanded": false,
      "isSelected": false,
      "symptoms": [
        {
          "id": 1,
          "name": "Ruam Kulit",
          "desc_normal": "Kemerahan ringan.", 
          "desc_danger": "Bernanah/bengkak.",
          "isSelected": false,
          
          // Detail Normal
          "normal_signs": [
            "Bintik merah kecil tidak menyebar",
            "Anak tidak demam",
            "Tidak gatal berlebihan"
          ],
          "normal_actions": [
            "Jaga kebersihan kulit",
            "Gunakan bedak/lotion bayi yang aman",
            "Pantau dalam 24 jam"
          ],
          
          // Detail Bahaya
          "danger_signs": [
            "Disertai demam tinggi (>38°C)",
            "Terlihat bintik berisi nanah atau cairan",
            "Menyebar luas dengan cepat"
          ],
          "danger_actions": [
            "Hubungi Tim Perawat",
            "Kirim foto untuk evaluasi",
            "Bawa ke fasilitas kesehatan jika memburuk"
          ]
        },
        {
          "id": 3,
          "name": "Luka Terbuka",
          "desc_normal": "Luka kecil.", 
          "desc_danger": "Pendarahan hebat.",
          "isSelected": false,
          
          "normal_signs": ["Luka goresan kecil", "Darah berhenti cepat", "Luka bersih"],
          "normal_actions": ["Bersihkan dengan air mengalir", "Beri antiseptik", "Tutup plester jika perlu"],
          
          "danger_signs": ["Luka dalam/lebar", "Pendarahan tidak berhenti", "Kotor/berkarat"],
          "danger_actions": ["Tekan luka untuk hentikan darah", "Segera ke UGD", "Perlu jahitan"]
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
          "isSelected": false,
          
          "normal_signs": ["Suhu 37.5°C - 38°C", "Anak masih mau minum/main", "Pipis lancar"],
          "normal_actions": ["Kompres hangat", "Beri banyak minum", "Observasi suhu tiap 4 jam"],
          
          "danger_signs": ["Suhu >38°C atau >40°C", "Anak kejang/mengigau", "Muntah terus menerus"],
          "danger_actions": ["Berikan penurun panas (Paracetamol)", "Segera ke RS/Dokter", "Jangan selimuti tebal"]
        },
        {
          "id": 5,
          "name": "Asma / Sesak",
          "desc_normal": "Napas berat.", 
          "desc_danger": "Bibir biru.",
          "isSelected": false,
          
          "normal_signs": ["Napas sedikit cepat sehabis main", "Tidak ada bunyi 'ngik'", "Wajah merah biasa"],
          "normal_actions": ["Istirahatkan anak", "Longgarkan pakaian", "Atur posisi duduk nyaman"],
          
          "danger_signs": ["Napas berbunyi (mengi)", "Bibir/kuku membiru", "Tarikan dinding dada dalam"],
          "danger_actions": ["Gunakan Inhaler/Nebulizer jika punya", "Segera ke IGD", "Posisi setengah duduk"]
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
          "isSelected": false,
          
          "normal_signs": ["BAB 3-4x sehari konsistensi bubur", "Anak tidak lemas", "Masih mau minum"],
          "normal_actions": ["Beri oralit/cairan elektrolit", "Lanjutkan makan (rendah serat)", "Jaga kebersihan popok"],
          
          "danger_signs": ["BAB cair >10x sehari", "Ada darah/lendir", "Mata cekung & lemas sekali"],
          "danger_actions": ["Segera infus/ke RS", "Cek feses di lab", "Waspada dehidrasi berat"]
        },
      ]
    },
  ].obs;

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
            tempResults.add(found);
          }
        }
      }
      searchResults.assignAll(tempResults);
    }
  }

  // 5. LOGIC CHECKBOX KATEGORI (INDUK)
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

  // 6. LOGIC CHECKBOX PENYAKIT (ANAK)
  void toggleSymptom(int catIndex, int symIndex, bool? val) {
    bool newValue = val ?? false;
    categoriesData[catIndex]['symptoms'][symIndex]['isSelected'] = newValue;
    categoriesData.refresh(); // Update UI
  }

  // 7. FUNGSI KAMERA / GALERI
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  // Reset gambar saat keluar halaman detail
  void resetImage() {
    selectedImagePath.value = '';
  }
}