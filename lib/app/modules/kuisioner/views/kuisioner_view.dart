import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kuisioner_controller.dart';

class KuisionerView extends GetView<KuisionerController> {
  const KuisionerView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Background seragam dengan Home
    final Color bgPage = const Color(0xFFFAFBFF);
    final Color primaryColor = const Color(0xFF2F80ED); // Biru Medis yang tenang

    return Scaffold(
      backgroundColor: bgPage,
      
      // --- APP BAR (Konsisten) ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Kuisioner Kesehatan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- HERO / INFO CARD ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // Gradient Biru Muda ke Putih
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.assignment_turned_in_rounded, color: primaryColor, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pra-Kunjungan",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Bantu dokter memahami kondisi Anda lebih cepat sebelum bertemu.",
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),

            // --- PERTANYAAN 1: KELUHAN ---
            _buildSectionHeader("1. Keluhan Utama"),
            _buildInputCard(
              child: TextField(
                controller: controller.complaintC,
                maxLines: 4,
                decoration: _inputDecoration("Ceritakan apa yang Anda rasakan... (Contoh: Nyeri perut kanan bawah sejak kemarin)"),
              ),
            ),

            const SizedBox(height: 25),

            // --- PERTANYAAN 2: SKALA NYERI (INTERAKTIF) ---
            _buildSectionHeader("2. Skala Nyeri"),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  // Visualisasi Emoticon yang Berubah-ubah
                  Obx(() {
                    double val = controller.painScale.value;
                    Color statusColor;
                    IconData statusIcon;

                    if (val < 4) {
                      statusColor = Colors.green;
                      statusIcon = Icons.sentiment_satisfied_alt_rounded;
                    } else if (val < 7) {
                      statusColor = Colors.orange;
                      statusIcon = Icons.sentiment_neutral_rounded;
                    } else {
                      statusColor = Colors.red;
                      statusIcon = Icons.sentiment_very_dissatisfied_rounded;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(statusIcon, size: 50, color: statusColor),
                        const SizedBox(width: 15),
                        Text(
                          "${val.toInt()}",
                          style: TextStyle(
                            fontSize: 40, 
                            fontWeight: FontWeight.bold, 
                            color: statusColor
                          ),
                        ),
                        const Text("/10", style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  
                  // Label Kiri Kanan
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tidak Sakit", style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                      Text("Sangat Sakit", style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  
                  // Slider Besar
                  Obx(() => SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: primaryColor,
                      inactiveTrackColor: Colors.blue.shade100,
                      trackHeight: 8.0,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: primaryColor.withOpacity(0.2),
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: controller.painScale.value,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (val) => controller.painScale.value = val,
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- PERTANYAAN 3: EFEK SAMPING ---
            _buildSectionHeader("3. Riwayat Obat / Efek Samping"),
            _buildInputCard(
              child: TextField(
                controller: controller.sideEffectC,
                maxLines: 3,
                decoration: _inputDecoration("Ada alergi atau efek samping obat sebelumnya? (Jika tidak ada, kosongkan saja)"),
              ),
            ),

            const SizedBox(height: 40),

            // --- TOMBOL SUBMIT ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.submitKuisioner(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shadowColor: primaryColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: controller.isLoading.value 
                  ? const SizedBox(
                      width: 20, height: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    ) 
                  : const Text("KIRIM JAWABAN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14, fontStyle: FontStyle.italic),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(20),
    );
  }
}