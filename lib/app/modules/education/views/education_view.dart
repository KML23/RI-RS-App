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

      body: Column(
        children: [
          // --- 1. SEARCH BAR & CATEGORIES ---
          Container(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
            color: bgPage,
            child: Column(
              children: [
                // Search Bar
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
                    // Shadow halus di search bar
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Kategori Chips (Horizontal Scroll)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip("Semua", true, primaryColor),
                      _buildCategoryChip("Nutrisi Lansia", false, primaryColor),
                      _buildCategoryChip("Olahraga", false, primaryColor),
                      _buildCategoryChip("Mental", false, primaryColor),
                      _buildCategoryChip("Penyakit Dalam", false, primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- 2. LIST ARTIKEL ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              itemCount: 5, // Dummy count, nanti pakai controller.articles.length
              itemBuilder: (context, index) {
                // Data Dummy untuk Preview (Nanti diganti data asli controller)
                final List<Map<String, String>> dummyArticles = [
                  {
                    "title": "Tips Menjaga Tensi Tetap Stabil di Usia Senja",
                    "category": "Kesehatan Jantung",
                    "readTime": "3 min baca",
                    "image": "https://img.freepik.com/free-photo/senior-woman-checking-blood-pressure_53876-14925.jpg" // Bisa ganti asset lokal
                  },
                  {
                    "title": "Makanan Kaya Serat yang Mudah Dikunyah",
                    "category": "Nutrisi",
                    "readTime": "5 min baca",
                    "image": "https://img.freepik.com/free-photo/fresh-fruit-salad_144627-18456.jpg"
                  },
                  {
                    "title": "Senam Ringan untuk Mencegah Nyeri Sendi",
                    "category": "Olahraga",
                    "readTime": "4 min baca",
                    "image": "https://img.freepik.com/free-photo/senior-woman-exercising-park_107420-84857.jpg"
                  },
                  {
                    "title": "Pentingnya Minum Air Putih Bagi Lansia",
                    "category": "Hidrasi",
                    "readTime": "2 min baca",
                    "image": "https://img.freepik.com/free-photo/glass-water_144627-16742.jpg"
                  },
                  {
                    "title": "Mengenal Gejala Awal Diabetes",
                    "category": "Penyakit Dalam",
                    "readTime": "6 min baca",
                    "image": "https://img.freepik.com/free-photo/glucometer-sugar-cubes_23-2148767988.jpg"
                  },
                ];

                final article = dummyArticles[index % dummyArticles.length];

                return GestureDetector( // Bungkus _buildArticleCard dengan GestureDetector (jika belum)
                  onTap: () {
                    // --- PINTU MASUK KE STEP BY STEP VIEW ---
                    Get.to(() => StepByStepView(
                      stepData: {
                        'title': article['title'], // Judul dari artikel yang diklik
                        'description': "Ini adalah contoh instruksi langkah demi langkah untuk ${article['title']}. Ikuti panduan animasi di atas agar hasilnya maksimal.",
                        // Nanti bisa tambah data lain seperti 'video_url' atau 'animation'
                      },
                    ));
                  },
                  child: _buildArticleCard(
                    title: article['title']!,
                    category: article['category']!,
                    readTime: article['readTime']!,
                  ),
                );
              },
            ),
          ),
        ],
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
        onSelected: (bool value) {}, // Nanti dihubungkan ke controller
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
  }) {
return GestureDetector(
      onTap: () {
        // --- NAVIGASI LANGSUNG KE SINI ---
        Get.to(() => StepByStepView(
          stepData: {
            'title': title,
            'description': "Lakukan gerakan ini secara perlahan selama 30 detik. Jangan memaksakan jika terasa nyeri.",
          },
        ));
      },
      child: Container(
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
                // Placeholder Icon kalau gambar error/loading
                child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[300], size: 40),
                // Nanti ganti dengan: Image.network(imageUrl, fit: BoxFit.cover)
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
      ),
    );
  }
}