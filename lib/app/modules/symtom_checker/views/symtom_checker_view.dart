import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/symtom_checker_controller.dart';
import '../../../routes/app_pages.dart';

// HMW4a: HALAMAN UTAMA (DAFTAR GEJALA)
class SymtomCheckerView extends GetView<SymtomCheckerController> {
  const SymtomCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.offNamed(Routes.HOME),
        ),
        title: const Text(
          'Panduan Gejala Anak',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH BAR
            TextField(
              controller: controller.searchController,
              onChanged: (val) => controller.onSearchChanged(val),
              decoration: InputDecoration(
                hintText: 'Cari apa yang dikhawatirkan:',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 20),
            
            // LOGIC TAMPILAN (SEARCH vs LIST KATEGORI)
            Expanded(
              child: Obx(() {
                // KONDISI 1: SEDANG MENCARI
                if (controller.isSearching.value) {
                  if (controller.searchResults.isEmpty) {
                    return const Center(child: Text("Gejala tidak ditemukan"));
                  }
                  return _buildSearchResults();
                } 
                
                // KONDISI 2: TAMPILAN UTAMA (KATEGORI & CHECKBOX)
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Filter berdasarkan kategori:", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.categoriesData.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryItem(index);
                          },
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET: Item Kategori (Induk)
  Widget _buildCategoryItem(int index) {
    var category = controller.categoriesData[index];
    
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: category['isSelected'],
                activeColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (val) {
                  controller.toggleCategory(index, val);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                category['category'], 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
              ),
            ),
          ],
        ),
        
        // Anak Checkbox (Daftar Penyakit)
        if (category['isSelected'] == true) 
          Padding(
            padding: const EdgeInsets.only(left: 34.0, top: 5, bottom: 10),
            child: Column(
              children: List.generate(category['symptoms'].length, (symIndex) {
                var symptom = category['symptoms'][symIndex];
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: InkWell(
                    onTap: () => _navigateToDetail(symptom, category['category']),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Checkbox(
                            value: symptom['isSelected'],
                            activeColor: Colors.blue.shade300, 
                            onChanged: (val) {
                              controller.toggleSymptom(index, symIndex, val);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(symptom['name']),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  // WIDGET: Hasil Pencarian
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final data = controller.searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          color: const Color(0xFFF8F5FE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(data['category_name'] ?? ""),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               _navigateToDetail(data, data['category_name']);
            },
          ),
        );
      },
    );
  }

  // Helper navigasi
  void _navigateToDetail(Map<String, dynamic> symptomData, String categoryName) {
    Map<String, dynamic> dataToSend = Map.from(symptomData);
    dataToSend['category'] = categoryName;
    Get.to(() => SymptomDetailView(data: dataToSend)); 
  }
}



// HMW4b: HALAMAN PILIHAN KONDISI (NORMAL vs BAHAYA)
class SymptomDetailView extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const SymptomDetailView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.blue, size: 18),
              Text("Kembali", style: TextStyle(color: Colors.blue, fontSize: 12))
            ],
          ),
          onPressed: () => Get.back(),
          iconSize: 60,
        ),
        leadingWidth: 100,
        title: Text(
          "Tampilan Normal/${data['name']}",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih jenis ${data['name']} yang paling mirip dengan kondisi anak anda:",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Card 1: Tampilan Normal
            InkWell(
              onTap: () {
                Get.find<SymtomCheckerController>().resetImage();
                Get.to(() => SymptomActionView(data: data, isDanger: false));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
                  border: Border.all(color: Colors.green.withOpacity(0.3)), // Border hijau
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tampilan Normal / Ringan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Text("[Foto ${data['name']} biasa]", style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text("• ${data['desc_normal']}", style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 15),
                    const Text("Lihat detail →", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Card 2: Perlu Diwaspadai
            InkWell(
              onTap: () {
                Get.find<SymtomCheckerController>().resetImage();
                Get.to(() => SymptomActionView(data: data, isDanger: true));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
                  border: Border.all(color: Colors.red.withOpacity(0.3)), 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Perlu Diwaspadai", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Text("[Foto ${data['name']} parah]", style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text("• ${data['desc_danger']}", style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 15),
                    const Text("Lihat detail →", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}



// HMW4c: HALAMAN ACTION & UPLOAD FOTO (DYNAMIC)
class SymptomActionView extends GetView<SymtomCheckerController> {
  final Map<String, dynamic> data;
  final bool isDanger;

  const SymptomActionView({super.key, required this.data, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    // [FIX] Logika pengambilan data berdasarkan isDanger
    List<String> signsList = isDanger 
        ? (data['danger_signs'] as List<String>? ?? ["Data tidak tersedia"]) 
        : (data['normal_signs'] as List<String>? ?? ["Data tidak tersedia"]);
        
    List<String> actionsList = isDanger 
        ? (data['danger_actions'] as List<String>? ?? ["Hubungi dokter"]) 
        : (data['normal_actions'] as List<String>? ?? ["Pantau anak"]);

    // Warna tema (Merah jika bahaya, Hijau jika normal)
    final themeColor = isDanger ? Colors.red : Colors.green;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.blue, size: 18),
              Text("Kembali", style: TextStyle(color: Colors.blue, fontSize: 12))
            ],
          ),
          onPressed: () => Get.back(),
          iconSize: 60,
        ),
        leadingWidth: 100,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "${data['name']}:",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              isDanger ? "Perlu Diwaspadai" : "Normal / Ringan",
              style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UPLOAD AREA
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Obx(() {
                    if (controller.selectedImagePath.value.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: themeColor.withOpacity(0.5), size: 40),
                          const SizedBox(height: 10),
                          const Text("Foto / Video", style: TextStyle(color: Colors.grey)),
                        ],
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(controller.selectedImagePath.value),
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  }),
                ),
              ),
              
              const SizedBox(height: 20),
              const Divider(thickness: 1.5),
              const SizedBox(height: 20),

              // DETAIL (Dynamic Text)
              Text(
                isDanger ? "Kondisi ini perlu diwaspadai:" : "Ciri-ciri kondisi normal:", 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              const SizedBox(height: 10),
              ...signsList.map((text) => _buildBulletPoint(text, themeColor)),
              
              const SizedBox(height: 20),
              const Divider(thickness: 1.5),
              const SizedBox(height: 20),

              // ACTION (Dynamic Text)
              Text(
                isDanger ? "Apa yang harus dilakukan?" : "Saran perawatan di rumah:", 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              const SizedBox(height: 10),
              ...actionsList.map((text) => _buildBulletPoint(text, themeColor)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 15))),
        ],
      ),
    );
  }
}

// Widget Bottom Navbar Dummy
Widget _buildBottomNav() {
  return Container(
    height: 60,
    color: Colors.white,
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.home, size: 30, color: Colors.black54),
        Icon(Icons.medication, size: 30, color: Colors.black54),
        Icon(Icons.notifications, size: 30, color: Colors.black54),
        Icon(Icons.person, size: 30, color: Colors.black54),
      ],
    ),
  );
}
//Hilma Salman Maulana (202210370311174)