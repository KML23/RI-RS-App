import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointment_controller.dart';
import '../../../routes/app_pages.dart'; // Import routes untuk navigasi bottom bar jika perlu

class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna Background sesuai gambar (kebiruan muda/abu muda)
    final Color bgColor = const Color(0xFFEEF2F5);
    final Color blueLink = const Color(0xFF2F80ED);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Persiapan Kunjungan\nKontrol',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.headset_mic_outlined,
              color: Colors.black87,
              size: 28,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CARD INFO DOKTER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kontrol dengan ${controller.doctorName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Tanggal
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        controller.appointmentDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Jam
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        controller.appointmentTime,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- JUDUL SECTION ---
            Text(
              "Kontrol dengan ${controller.doctorName}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),

            const SizedBox(height: 15),

            // --- LIST TUGAS (Dynamic Rendering) ---
            Obx(
              () => Column(
                children: controller.preparationList.map((item) {
                  return _buildTaskCard(item, blueLink);
                }).toList(),
              ),
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION BAR (Sesuai Gambar) ---
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home_filled,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () => Get.offAllNamed(Routes.HOME),
            ),
            IconButton(
              // Icon link/pill sesuai gambar
              icon: const Icon(
                Icons.medication_outlined,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person, size: 30, color: Colors.black87),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> item, Color blueLink) {
    bool isDone = item['type'] == 'done';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Agar icon tetap di atas jika teks panjang
        children: [
          // ICON CHECKBOX / RADIO
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(
              isDone
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),

          // CONTENT TEKS
          Expanded(
            child: isDone
                ? Text(
                    item['text'],
                    style:
                        TextStyle(
                          color:
                              Colors.grey[600], // Teks agak pudar jika selesai
                          decoration: TextDecoration
                              .underline, // Garis bawah sesuai gambar
                          decorationColor: blueLink,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          shadows: [
                            Shadow(color: blueLink, offset: Offset(0, -2)),
                          ], // Trick untuk underline warna biru tapi teks beda warna (opsional, simplenya pakai style biasa)
                        ).copyWith(
                          color: blueLink,
                          decoration: TextDecoration.underline,
                        ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['status'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          item['actionText'],
                          style: TextStyle(
                            color: blueLink,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
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
