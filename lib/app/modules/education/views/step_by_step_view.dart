import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepByStepView extends StatelessWidget {
  final String title;
  final List<dynamic> steps;

  // Kita gunakan RxInt lokal untuk handle perubahan halaman tanpa controller terpisah
  final RxInt activeIndex = 0.obs;

  StepByStepView({super.key, required this.title, required this.steps});

  @override
  Widget build(BuildContext context) {
    final Color bgPage = const Color(0xFFFAFBFF);
    final Color primaryColor = const Color(0xFF2F80ED);

    // Jika tidak ada steps data dari Firebase, tampilkan default
    if (steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail"), centerTitle: true),
        body: const Center(child: Text("Tidak ada panduan langkah untuk artikel ini.")),
      );
    }

    return Scaffold(
      backgroundColor: bgPage,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black87, size: 28),
          onPressed: () => Get.back(),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: Obx(() {
        // Data langkah yang aktif saat ini
        var currentStepData = steps[activeIndex.value];
        int currentStepNum = activeIndex.value + 1;
        int totalStep = steps.length;
        double progress = currentStepNum / totalStep;

        return Column(
          children: [
            // --- 1. PROGRESS BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Langkah $currentStepNum dari $totalStep", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                      Text("${(progress * 100).toInt()}% Selesai", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // --- 2. MEDIA VISUAL (GAMBAR/VIDEO) ---
                    // Nanti bisa ambil dari currentStepData['image'] jika ada di Firebase
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(color: Colors.grey.shade100),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image_outlined, size: 60, color: primaryColor.withOpacity(0.5)),
                                const SizedBox(height: 10),
                                Text("Visual Langkah ${activeIndex.value + 1}", style: TextStyle(color: Colors.grey[500]))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- 3. INSTRUKSI TEKS ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: primaryColor, size: 20),
                              const SizedBox(width: 10),
                              // Judul Langkah (Misal: "Persiapan Alat")
                              Expanded(
                                child: Text(
                                  currentStepData['title'] ?? "Instruksi", 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Deskripsi Langkah
                          Text(
                            currentStepData['description'] ?? "Ikuti langkah ini dengan hati-hati.",
                            style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 4. NAVIGATION BUTTONS ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
              ),
              child: Row(
                children: [
                  // Tombol SEBELUMNYA
                  if (activeIndex.value > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () => activeIndex.value--,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.grey),
                      ),
                    )
                  else
                    const Spacer(flex: 1), // Spacer biar layout tetap rapi saat tombol back hilang

                  const SizedBox(width: 15),

                  // Tombol LANJUT / SELESAI
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {
                        if (activeIndex.value < steps.length - 1) {
                          activeIndex.value++; // Lanjut ke step berikutnya
                        } else {
                          Get.back(); // Selesai, tutup halaman
                          Get.snackbar("Selesai", "Panduan telah selesai dibaca", backgroundColor: Colors.green, colorText: Colors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: primaryColor.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            activeIndex.value < steps.length - 1 ? "LANJUT LANGKAH ${activeIndex.value + 2}" : "SELESAI",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                          ),
                          const SizedBox(width: 10),
                          Icon(activeIndex.value < steps.length - 1 ? Icons.arrow_forward_rounded : Icons.check_circle_outline, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}