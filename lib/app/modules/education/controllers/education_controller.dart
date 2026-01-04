import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EducationController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  // Data Artikel Reactive
  var educationList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  // --- AMBIL DATA DARI FIRESTORE ---
  void fetchArticles() async {
    try {
      isLoading.value = true;
      // Ambil semua dokumen di koleksi 'articles'
      QuerySnapshot snapshot = await firestore.collection('articles').get();
      
      var dataList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        // Kita rapikan datanya biar aman
        return {
          "id": doc.id,
          "title": data['title'] ?? "Tanpa Judul",
          "category": data['category'] ?? "Umum",
          "readTime": data['read_time'] ?? "3 min", // Pastikan field di firestore 'read_time'
          "image": data['image_url'] ?? "", // Pastikan field di firestore 'image_url'
          "description": data['description'] ?? "Tidak ada deskripsi singkat.",
          // Jika nanti ada steps (array), ambil juga
          "steps": data['steps'] ?? [] 
        };
      }).toList();

      educationList.assignAll(dataList);
      
    } catch (e) {
      print("Error ambil artikel: $e");
      Get.snackbar("Error", "Gagal memuat artikel: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi Refresh (Opsional, buat narik layar ke bawah)
  Future<void> refreshData() async {
    fetchArticles();
  }
}