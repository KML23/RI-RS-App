import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilers/app/modules/education/views/step_by_step_view.dart';
import '../controllers/education_controller.dart';

class EducationView extends GetView<EducationController> {
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Background seragam
    final Color bgPage = const Color(0xFFFAFBFF);
    final Color primaryColor = const Color(0xFF2F80ED);

    return Scaffold(
      backgroundColor: bgPage,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pusat Edukasi',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: Column(
          children: [
            // --- 1. SEARCH BAR & CATEGORIES ---
            Container(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              color: bgPage,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Cari artikel kesehatan...",
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Kategori Chips (Statis dulu, nanti bisa dinamis)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip("Semua", true, primaryColor),
                        _buildCategoryChip("Nutrisi Lansia", false, primaryColor),
                        _buildCategoryChip("Olahraga", false, primaryColor),
                        _buildCategoryChip("Mental", false, primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. LIST ARTIKEL (REAL DATA) ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.educationList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined, size: 50, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("Belum ada artikel", style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  itemCount: controller.educationList.length,
                  itemBuilder: (context, index) {
                    final article = controller.educationList[index];

                    return GestureDetector(
                      onTap: () {
                        // --- UPDATE PANGGILAN STEP BY STEP ---
                        
                        // Cek apakah artikel punya langkah-langkah (steps)
                        // Jika tidak ada di Firebase, kita buat dummy 1 langkah biar tidak error
                        List dynamicSteps = article['steps'] ?? [];
                        if (dynamicSteps.isEmpty) {
                          dynamicSteps = [
                            {
                              "title": "Info Umum",
                              "description": article['description'] ?? "Silakan baca deskripsi artikel ini."
                            }
                          ];
                        }

                        Get.to(() => StepByStepView(
                          title: article['title'],
                          steps: dynamicSteps, // Kirim List langkah-langkah
                        ));
                      },
                      child: _buildArticleCard(
                        title: article['title'],
                        category: article['category'],
                        readTime: article['readTime'],
                        imageUrl: article['image'],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildCategoryChip(String label, bool isActive, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isActive ? Colors.white : Colors.grey[600],
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        selected: isActive,
        onSelected: (bool value) {}, 
        backgroundColor: Colors.white,
        selectedColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isActive ? primaryColor : Colors.grey.shade200,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String category,
    required String readTime,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail Gambar (Kiri)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover, 
                      errorBuilder: (c, o, s) => Icon(Icons.broken_image, color: Colors.grey[300]))
                  : Icon(Icons.image_not_supported_outlined, color: Colors.grey[300], size: 40),
            ),
          ),
          
          // Konten Teks (Kanan)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori Kecil
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Judul Artikel
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Durasi Baca & Icon Panah
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        readTime,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}