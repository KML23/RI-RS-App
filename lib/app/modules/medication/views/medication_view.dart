import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medication_controller.dart';

class MedicationView extends GetView<MedicationController> {
  const MedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgPage = const Color(0xFFEEF2F5);

    return Scaffold(
      backgroundColor: bgPage,
      // AppBar Dinamis
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: Obx(() {
          // Jika di Reminder (0), kosong
          if (controller.viewState.value == 0) return const SizedBox();

          // Tombol Kembali
          return GestureDetector(
            onTap: () {
              if (controller.viewState.value == 2) {
                controller.backToList(); // Dari Detail -> List
              } else {
                controller.backToReminder(); // Dari List -> Reminder (Opsional)
              }
            },
            child: Row(
              children: const [
                SizedBox(width: 10),
                Icon(Icons.arrow_back_ios, size: 16, color: Colors.blue),
                Text(
                  "Kembali",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ],
            ),
          );
        }),
        title: Obx(
          () => Text(
            controller.viewState.value == 2
                ? 'Detail Paracetamol'
                : 'Jadwal Obat Saya',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Obx(
            () => controller.viewState.value == 0
                ? IconButton(
                    icon: const Icon(
                      Icons.headset_mic_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  )
                : const SizedBox(),
          ),
        ],
      ),

      // SWITCH TAMPILAN BERDASARKAN STATE
      body: Obx(() {
        if (controller.viewState.value == 0) {
          return _buildReminderView();
        } else if (controller.viewState.value == 1) {
          return _buildScheduleListView();
        } else {
          return _buildDetailView(); // Tampilan Baru
        }
      }),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (val) {},
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 22,
              child: Icon(Icons.medication, color: Colors.white, size: 24),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: '',
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. TAMPILAN PENGINGAT (HITAM)
  // ==========================================
  Widget _buildReminderView() {
    final Color cardColor = const Color(0xFF4A4A4A);
    // ... (Kode sama seperti sebelumnya) ...
    // Biar tidak kepanjangan, saya ringkas bagian ini karena sudah ada di chat sebelumnya.
    // Intinya berisi Card Hitam + Tombol Hijau Merah.
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "! Asisten Rawat Mandiri",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),
              const Text(
                "Waktunya Minum Obat!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.5,
                    child: const Icon(
                      Icons.medication_outlined,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Paracetamol 500mg",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.markAsTaken(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF28A745),
                      ),
                      child: Text("SUDAH"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.snoozeReminder(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB00020),
                      ),
                      child: Text("TUNDA 10 MENIT"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 2. TAMPILAN LIST (PUTIH)
  // ==========================================
  Widget _buildScheduleListView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Hari ini, 19 oktober",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Loop Data
        ...controller.medicationList.map((item) {
          // Cek jika obatnya Paracetamol, kita bungkus dengan InkWell agar bisa diklik
          bool isParacetamol = item['name'].toString().toLowerCase().contains(
            'paracetamol',
          );

          return GestureDetector(
            onTap: () {
              if (isParacetamol) controller.showDetail(item['name']);
            },
            child: _buildMedicineCard(
              name: item['name'],
              schedules: item['schedules'],
              isClickable:
                  isParacetamol, // Opsional: beri visual effect kalau bisa diklik
            ),
          );
        }),

        const SizedBox(height: 30),
        const Center(
          child: Text(
            "+ Tambahkan Pengingat Manual",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Helper Widget untuk Card di List
  Widget _buildMedicineCard({
    required String name,
    required List schedules,
    bool isClickable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Jika bisa diklik (Paracetamol), beri border biru tipis agar user tau
        border: isClickable
            ? Border.all(color: Colors.blue.withOpacity(0.3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.rotate(
            angle: -0.5,
            child: const Icon(Icons.medication_outlined, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 8),
                ...schedules.map(
                  (s) => Text(
                    "• ${s['time']} ${s['taken'] ? '✓' : ''}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. TAMPILAN DETAIL (SESUAI GAMBAR BARU)
  // ==========================================
  Widget _buildDetailView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- KARTU INFO OBAT ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Transform.rotate(
                  angle: -0.5,
                  child: const Icon(
                    Icons.medication_outlined,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PARACETAMOL 500mg",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Diminum 3x sehari, 1 tablet",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- PERINGATAN ---
          const Text(
            "!!! Minum setelah makan untuk\nmenghindari iritasi lambung !!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 40),

          // --- HEADER LOG ---
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Log kepatuhan (7 hari terakhir )",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // --- KARTU LOG KEPATUHAN ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SECTION 1: HARI INI
                const Text(
                  "Hari ini (2/3)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusItem("08.00", 1),
                    _buildStatusItem("14.05", 1),
                    _buildStatusItem("20.00", 0),
                  ],
                ),

                const SizedBox(height: 20),
                // GARIS PUTUS-PUTUS (Manual Divider)
                Row(
                  children: List.generate(
                    30,
                    (index) => Expanded(
                      child: Container(
                        color: index % 2 == 0
                            ? Colors.transparent
                            : Colors.grey[300],
                        height: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // SECTION 2: KEMARIN
                const Text(
                  "Kemarin (3/3)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusItem("08.00", 1),
                    _buildStatusItem("14.05", 2),
                    _buildStatusItem("20.00", 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk item status (Jam + Icon)
  Widget _buildStatusItem(String time, int status) {
    // status: 0 = Pending (-), 1 = Done (Check), 2 = Missed (X)
    return Column(
      children: [
        Row(
          children: [
            if (status == 1) ...[
              const Icon(Icons.check, size: 20, color: Colors.black87),
            ] else if (status == 2) ...[
              const Icon(Icons.close, size: 20, color: Colors.red),
            ] else ...[
              Container(width: 12, height: 4, color: Colors.black87), // Strip
              const SizedBox(width: 4),
            ],
            const SizedBox(width: 5),
            Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
        // Text Tambahan khusus "Terlewat"
        if (status == 2)
          const Text(
            "Terlewat",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
      ],
    );
  }
}
