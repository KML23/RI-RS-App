import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kuisioner_controller.dart';

class KuisionerView extends GetView<KuisionerController> {
  const KuisionerView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgPage = const Color(0xFFF5F9FC);
    final Color primaryBlue = const Color(0xFF2F80ED);

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Kuisioner\nPra-kunjungan',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: Text(
                "Data ini akan membantu dokter memahami perkembangan kondisi Anda lebih cepat.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            // Soal 1
            _buildQuestionCard(
              "1",
              "Apa keluhan utama Anda saat ini?",
              TextField(
                controller: controller.complaintC,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Contoh: Nyeri perut...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Soal 2
            _buildQuestionCard(
              "2",
              "Bagaimana skala nyeri Anda (0-10)?",
              Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "0",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "${controller.painScale.value.toInt()}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          "10",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Slider(
                      value: controller.painScale.value,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      activeColor: Colors.blue,
                      onChanged: (val) => controller.painScale.value = val,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Soal 3
            _buildQuestionCard(
              "3",
              "Efek samping obat terakhir?",
              TextField(
                controller: controller.sideEffectC,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Contoh: Mual...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Kirim
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitKuisioner(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Kirim Jawaban",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String number, String question, Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. $question",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
