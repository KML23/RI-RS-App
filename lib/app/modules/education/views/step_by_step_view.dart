import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepByStepView extends StatelessWidget {
  final Map<String, dynamic> stepData;

  const StepByStepView({super.key, required this.stepData});

  @override
  Widget build(BuildContext context) {
    // 1. Background Seragam
    final Color bgPage = const Color(0xFFFAFBFF);
    final Color primaryColor = const Color(0xFF2F80ED);

    // Dummy Data untuk Progress (Nanti bisa diambil dari controller)
    int currentStep = 1;
    int totalStep = 3;
    double progress = currentStep / totalStep;

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
          stepData['title'] ?? 'Panduan',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),

      body: Column(
        children: [
          // --- 1. PROGRESS BAR ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Langkah $currentStep dari $totalStep", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
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
                  // --- 2. MEDIA VISUAL (FOKUS UTAMA) ---
                  Container(
                    height: 280, // Lebih besar
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Placeholder Background
                          Container(color: Colors.grey.shade100),
                          
                          // Icon Play / Gif Placeholder
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle_fill_rounded, size: 60, color: primaryColor.withOpacity(0.5)),
                              const SizedBox(height: 10),
                              Text(
                                "Putar Animasi",
                                style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          
                          // Jika ada image nanti: Image.network(src, fit: BoxFit.cover),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 3. INSTRUKSI TEKS ---
                  Container(
                    padding: const EdgeInsets.all(20),
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
                            const Text("Instruksi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          stepData['description'] ?? "Ikuti gerakan seperti yang ditunjukkan pada animasi di atas secara perlahan.",
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6, // Spasi baris lega
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 4. NAVIGATION BUTTONS (BESAR) ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                // Tombol KEMBALI (Outline)
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.snackbar("Info", "Kembali ke langkah sebelumnya");
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 15),
                
                // Tombol LANJUT (Solid Primary)
                Expanded(
                  flex: 3, // Lebih lebar karena aksi utama
                  child: ElevatedButton(
                    onPressed: () {
                       // Logika next step
                       Get.back(); // Sementara back dulu
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: primaryColor.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("LANJUT LANGKAH 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}