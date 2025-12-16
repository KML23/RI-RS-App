import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import 'chat_room_view.dart';

class ChatHomeView extends GetView<ChatController> {
  const ChatHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan Controller sudah di-put di Binding sebelumnya
    // atau gunakan Get.put(ChatController()) jika testing tanpa binding.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Pusat Bantuan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Input Pertanyaan Awal ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    "Punya pertanyaan seputar perawatan Anda?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "[Ketik Pertanyaan Anda]",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                    // Opsional: Bisa langsung kirim ke chat jika di-enter
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        controller.messages
                            .clear(); // Reset chat lama (opsional)
                        controller.sendMessage(val);
                        Get.to(() => const ChatRoomView());
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              "Atau Pilih Salah Satu Opsi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),

            // --- Section 2: Tombol Pilihan (AI vs Perawat) ---
            Row(
              children: [
                // Tombol AI
                Expanded(
                  child: _buildOptionCard(
                    icon: Icons.smart_toy_outlined,
                    title: "AI",
                    subtitle: "Tanya Asisten AI",
                    onTap: () {
                      // Reset state ke mode AI
                      controller.isNurseJoined.value = false;
                      Get.to(() => const ChatRoomView());
                    },
                  ),
                ),
                const SizedBox(width: 15),
                // Tombol Perawat
                Expanded(
                  child: _buildOptionCard(
                    icon: Icons.medical_services_outlined,
                    title: "Tim\nPerawat",
                    subtitle: "Hubungi Tim\nPerawat",
                    onTap: () {
                      // Langsung trigger logika perawat
                      controller.connectToNurse();
                      Get.to(() => const ChatRoomView());
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            const Text(
              "Riwayat Percakapan Anda",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),

            // --- Section 3: Riwayat (Dummy) ---
            _buildHistoryItem("Cara Merawat Luka Pasca Operasi"),
            _buildHistoryItem("Pola Makan & Istirahat Pasca Operasi"),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(icon, color: Colors.blue)),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
