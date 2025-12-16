import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart'; // Pastikan path ini sesuai dengan project Anda

class SymtomCheckerController extends GetxController {
  // --- VARIABLES ---
  final searchController = TextEditingController();
  var isSearching = false.obs;
  var selectedCategoryIndex = 0.obs;

  // Data User
  var userName = "Memuat...".obs;
  var userRM = "...".obs;

  // Image Picker
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  var searchResults = <Map<String, dynamic>>[].obs;

  // --- DATA MASTER ---
  // Pastikan struktur data ini sesuai dengan kebutuhan Anda
  var categoriesData = <Map<String, dynamic>>[
    {
      "category": "Umum",
      "color": const Color(0xFFFF6B6B),
      "symptoms": [
        {"name": "Demam", "id": 1},
        {"name": "Batuk", "id": 2},
        {"name": "Flu", "id": 3},
      ]
    },
    {
      "category": "Pencernaan",
      "color": const Color(0xFF4ECDC4),
      "symptoms": [
        {"name": "Mual", "id": 4},
        {"name": "Muntah", "id": 5},
        {"name": "Sakit Perut", "id": 6},
      ]
    },
    // Tambahkan kategori lain di sini...
  ].obs;

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

  // --- LIFECYCLE ---
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // --- METHODS ---

  // 1. Fungsi Pencarian
  void onSearchChanged(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
    } else {
      isSearching.value = true;
      List<Map<String, dynamic>> tempResults = [];
      
      for (var cat in categoriesData) {
        if (cat['symptoms'] != null) {
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
      }
      searchResults.assignAll(tempResults);
    }
  }

  // 2. Ganti Kategori
  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  // 3. Ambil Data User dari Firestore
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

  // 4. Pilih Gambar (Fixed)
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // 5. Reset Gambar (Fixed)
  void resetImage() {
    selectedImagePath.value = '';
  }

  // 6. Logout
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}