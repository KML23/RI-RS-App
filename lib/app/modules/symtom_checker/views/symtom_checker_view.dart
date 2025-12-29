import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilers/app/routes/app_pages.dart';
import '../controllers/symtom_checker_controller.dart';

class SymtomCheckerView extends GetView<SymtomCheckerController> {
  const SymtomCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Cek Gejala Anak',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- 1. SEARCH BAR ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: controller.searchController,
              onChanged: (val) => controller.onSearchChanged(val),
              decoration: InputDecoration(
                hintText: 'Cari gejala (misal: demam, ruam)...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // --- 2. KONTEN UTAMA ---
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return _buildSearchResults();
              }
              return Column(
                children: [
                  // TAB KATEGORI (Horizontal)
                  _buildCategoryTabs(),
                  
                  // GRID GEJALA (Visual Catalog)
                  Expanded(child: _buildSymptomGrid()),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categoriesData.length,
        separatorBuilder: (c, i) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedCategoryIndex.value == index;
            var cat = controller.categoriesData[index];
            
            // PERBAIKAN DI SINI:
            // Ambil color langsung, jangan dibungkus Color() lagi
            Color catColor = cat['color']; 

            return GestureDetector(
              onTap: () => controller.changeCategory(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? catColor : Colors.white, // FIX
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                  boxShadow: isSelected 
                      ? [BoxShadow(color: catColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))] // FIX
                      : [],
                ),
                child: Row(
                  children: [
                    Icon(cat['icon'], size: 18, color: isSelected ? Colors.white : Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      cat['category'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildSymptomGrid() {
    var currentCat = controller.categoriesData[controller.selectedCategoryIndex.value];
    List symptoms = currentCat['symptoms'];
    
    // PERBAIKAN DI SINI:
    // Hapus Color(), langsung ambil nilainya
    Color themeColor = currentCat['color']; 

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.85, 
      ),
      itemCount: symptoms.length,
      itemBuilder: (context, index) {
        var sym = symptoms[index];
        return GestureDetector(
          onTap: () => _navigateToDetail(sym, currentCat['category']),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(sym['icon'], size: 36, color: themeColor),
                ),
                const SizedBox(height: 15),
                Text(
                  sym['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Cek kondisi",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final data = controller.searchResults[index];
        
        // Handling color safety kalau-kalau null
        Color itemColor = data['color'] is Color 
            ? data['color'] 
            : Color(data['color'] ?? 0xFF000000);

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: itemColor.withOpacity(0.1),
              child: Icon(data['icon'], color: itemColor),
            ),
            title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(data['category_name'] ?? ""),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => _navigateToDetail(data, data['category_name']),
          ),
        );
      },
    );
  }

  void _navigateToDetail(Map<String, dynamic> symptomData, String categoryName) {
    Map<String, dynamic> dataToSend = Map.from(symptomData);
    dataToSend['category'] = categoryName;
    Get.to(() => SymptomDetailView(data: dataToSend)); 
  }
}

// --- CLASS LAIN DI BAWAHNYA TETAP SAMA (DETAIL VIEW & ACTION VIEW) ---
// (Copy paste kode bawahnya dari file lama kamu kalau ada custom, 
// tapi bagian SymtomCheckerView di atas ini yang penting diperbaiki)

class SymptomDetailView extends StatelessWidget {
  final Map<String, dynamic> data;
  const SymptomDetailView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC), 
      appBar: AppBar(
        title: Text(data['name'], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Manakah yang paling mirip dengan kondisi anak?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 25),

            _buildComparisonCard(
              context,
              title: "Normal / Ringan",
              desc: data['desc_normal'],
              color: Colors.green,
              isDanger: false,
            ),

            const SizedBox(height: 20),

            _buildComparisonCard(
              context,
              title: "Perlu Diwaspadai",
              desc: data['desc_danger'],
              color: Colors.red,
              isDanger: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(BuildContext context, {
    required String title, required String desc, required Color color, required bool isDanger
  }) {
    return GestureDetector(
      onTap: () {
        Get.find<SymtomCheckerController>().resetImage();
        Get.to(() => SymptomActionView(data: data, isDanger: isDanger));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Icon(isDanger ? Icons.warning_amber : Icons.check_circle_outline, color: color),
                  const SizedBox(width: 10),
                  Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: color),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.image, color: Colors.grey[400], size: 30),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(desc, style: const TextStyle(fontSize: 15, height: 1.4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomActionView extends GetView<SymtomCheckerController> {
  final Map<String, dynamic> data;
  final bool isDanger;

  const SymptomActionView({super.key, required this.data, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    List<String> signs = isDanger 
        ? (data['danger_signs'] as List<String>? ?? []) 
        : (data['normal_signs'] as List<String>? ?? []);
    List<String> actions = isDanger 
        ? (data['danger_actions'] as List<String>? ?? []) 
        : (data['normal_actions'] as List<String>? ?? []);

    Color themeColor = isDanger ? Colors.red : Colors.green;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: Text(isDanger ? "Waspada" : "Normal", style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => controller.pickImage(),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: Obx(() {
                  if (controller.selectedImagePath.value.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 10),
                        const Text("Ambil Foto untuk Dokumentasi", style: TextStyle(color: Colors.grey)),
                      ],
                    );
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(File(controller.selectedImagePath.value), fit: BoxFit.cover),
                    );
                  }
                }),
              ),
            ),
            
            const SizedBox(height: 30),

            _buildSectionTitle("Tanda - tanda:", themeColor),
            ...signs.map((s) => _buildBullet(s)),

            const SizedBox(height: 25),

            _buildSectionTitle("Saran Tindakan:", themeColor),
            ...actions.map((s) => _buildBullet(s)),
            
            const SizedBox(height: 40),
            
            if (isDanger)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.CHAT);
                  }, 
                  icon: const Icon(Icons.support_agent),
                  label: const Text("Hubungi Perawat Sekarang"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4))),
        ],
      ),
    );
  }
}