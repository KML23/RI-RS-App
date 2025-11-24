import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/education_controller.dart';

class EducationView extends GetView<EducationController> {
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Obx(() => controller.isDetailOpen.value 
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
              onPressed: () => controller.closeDetail(),
            )
          : const SizedBox() // Kosong jika di list utama (krn ada bottom nav nanti)
        ),
        title: Obx(() => Text(
          controller.isDetailOpen.value ? 'Detail Panduan' : 'Pusat Edukasi',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isDetailOpen.value) {
          return _buildDetailView();
        } else {
          return _buildListView();
        }
      }),
    );
  }

  // --- TAMPILAN 1: LIST PANDUAN ---
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.educationList.length,
      itemBuilder: (context, index) {
        final item = controller.educationList[index];
        return GestureDetector(
          onTap: () => controller.openDetail(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Thumbnail Warna/Gambar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(item['thumbnail_color']),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['category'],
                          style: const TextStyle(
                            color: Colors.blue, 
                            fontSize: 12, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              item['duration'],
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // --- TAMPILAN 2: DETAIL PANDUAN (VIDEO & LANGKAH) ---
  Widget _buildDetailView() {
    final guide = controller.selectedGuide;
    final List steps = guide['steps'] ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. VIDEO PLAYER PLACEHOLDER
          Container(
            width: double.infinity,
            height: 220,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.play_circle_fill, color: Colors.white, size: 60),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.black54,
                    child: Text(
                      guide['duration'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide['title'],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tonton video ringkasan di atas atau ikuti panduan langkah demi langkah di bawah ini:",
                  style: TextStyle(color: Colors.grey),
                ),
                
                const SizedBox(height: 25),
                const Text(
                  "Panduan Visual",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // 2. STEPS LIST
                if (steps.isEmpty)
                  const Center(child: Text("Belum ada detail langkah."))
                else
                  ...steps.map((step) => _buildStepCard(step)).toList(),

                const SizedBox(height: 40),
                
                // Tombol Selesai
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => controller.closeDetail(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Saya Sudah Paham"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(Map<String, dynamic> step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor Langkah
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(
              "${step['step_no']}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  step['description'],
                  style: TextStyle(color: Colors.grey[700], height: 1.5),
                ),
                const SizedBox(height: 10),
                // Placeholder Gambar Visual Langkah
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!)
                  ),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}