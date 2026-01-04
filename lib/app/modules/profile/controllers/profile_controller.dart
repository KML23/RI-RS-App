import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Data User Reactive (Awalnya kosong/loading)
  var userProfile = <String, dynamic>{
    "name": "Memuat...",
    "rm_number": "...",
    "email": "...",
    "phone": "-",
    "age": "-",
    "image": "https://i.pravatar.cc/150?img=11" // Default avatar
  }.obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // --- FUNGSI AMBIL DATA DARI FIREBASE ---
  void fetchUserProfile() async {
    try {
      isLoading.value = true;
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        // 1. Ambil data dari Firestore berdasarkan UID
        DocumentSnapshot userDoc = await firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          
          // 2. Hitung Umur dari Tanggal Lahir (dob)
          String age = "-";
          if (data['dob'] != null) {
            age = _calculateAge(data['dob']);
          }

          // 3. Update UI dengan Data Asli
          userProfile.value = {
            "name": data['name'] ?? "User Tanpa Nama",
            "rm_number": data['rm'] ?? "-", // Pastikan key di Firestore 'rm'
            "email": currentUser.email ?? "-",
            "phone": data['phone'] ?? "-",
            "age": "$age Tahun",
            "image": data['photo_url'] ?? "https://i.pravatar.cc/150?img=11"
          };
        }
      }
    } catch (e) {
      print("Error ambil profil: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper Hitung Umur
  String _calculateAge(String dobString) {
    try {
      // Format dob di Firestore harus: "dd / MM / yyyy" (Sesuai register controller)
      List<String> parts = dobString.split(' / ');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        
        DateTime dob = DateTime(year, month, day);
        DateTime now = DateTime.now();
        
        int age = now.year - dob.year;
        if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
          age--;
        }
        return age.toString();
      }
    } catch (e) {
      return "-";
    }
    return "-";
  }

  // Fungsi Logout
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
        await auth.signOut();
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}