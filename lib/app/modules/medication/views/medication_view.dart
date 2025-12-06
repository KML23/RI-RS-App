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

      // --- APP BAR DINAMIS ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: Obx(() {
          // Jika di State 0 (Reminder Hitam), tidak ada tombol kembali
          if (controller.viewState.value == 0) return const SizedBox();

          // Tombol Kembali
          return GestureDetector(
            onTap: () {
              // Jika sedang di Detail (2) atau Tambah (3), kembali ke List (1)
              if (controller.viewState.value == 2 || controller.viewState.value == 3) {
                controller.backToList();
              } else {
                // Jika di List (1), kembali ke Reminder (0) - Opsional
                controller.backToReminder();
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
        title: Obx(() {
          // Judul AppBar berubah sesuai State
          String title = 'Jadwal Obat Saya';
          if (controller.viewState.value == 2) title = 'Detail Paracetamol';
          if (controller.viewState.value == 3) title = 'Tambah Pengingat'; // Judul Baru
          
          return Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          );
        }),
        actions: [
          Obx(() => controller.viewState.value == 0
              ? IconButton(
                  icon: const Icon(Icons.headset_mic_outlined, color: Colors.black87),
                  onPressed: () {},
                )
              : const SizedBox()),
        ],
      ),

      // --- BODY SWITCHER ---
      body: Obx(() {
        switch (controller.viewState.value) {
          case 0:
            return _buildReminderView();
          case 1:
            return _buildScheduleListView();
          case 2:
            return _buildDetailView();
          case 3:
            return _buildAddReminderView(); // Tampilan Form Baru
          default:
            return _buildScheduleListView();
        }
      }),

      // --- BOTTOM NAVIGATION BAR ---
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
  // STATE 0: TAMPILAN PENGINGAT (HITAM)
  // ==========================================
  Widget _buildReminderView() {
    final Color cardColor = const Color(0xFF4A4A4A);
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
              const Text("! Asisten Rawat Mandiri", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 30),
              const Text(
                "Waktunya Minum Obat!",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.5,
                    child: const Icon(Icons.medication_outlined, color: Colors.black, size: 40),
                  ),
                  const SizedBox(width: 15),
                  const Text("Paracetamol 500mg", style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.markAsTaken(),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28A745)),
                      child: const Text("SUDAH"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.snoozeReminder(),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB00020)),
                      child: const Text("TUNDA 10 MENIT"),
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
  // STATE 1: TAMPILAN LIST (PUTIH)
  // ==========================================
  Widget _buildScheduleListView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Hari ini, 19 oktober",
          style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // List Obat
        ...controller.medicationList.map((item) {
          bool isParacetamol = item['name'].toString().toLowerCase().contains('paracetamol');
          return GestureDetector(
            onTap: () {
              if (isParacetamol) controller.showDetail(item['name']);
            },
            child: _buildMedicineCard(
              name: item['name'],
              schedules: item['schedules'],
              isClickable: isParacetamol,
            ),
          );
        }).toList(),

        const SizedBox(height: 30),
        
        // Tombol Tambah Manual (SUDAH DIPERBAIKI)
        Center(
          child: TextButton.icon(
            onPressed: () => controller.goToAddReminder(), // Panggil fungsi di Controller
            icon: const Icon(Icons.add, color: Colors.black87),
            label: const Text(
              "Tambahkan Pengingat Manual",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STATE 2: TAMPILAN DETAIL
  // ==========================================
  Widget _buildDetailView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Info Obat
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              children: [
                Transform.rotate(
                  angle: -0.5,
                  child: const Icon(Icons.medication_outlined, size: 40, color: Colors.black),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PARACETAMOL 500mg", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text("Diminum 3x sehari, 1 tablet", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "!!! Minum setelah makan untuk\nmenghindari iritasi lambung !!!",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 40),
          // Log Kepatuhan
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Log kepatuhan (7 hari terakhir )", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hari ini (2/3)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16)),
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
                Divider(color: Colors.grey[300]), // Garis simple
                const SizedBox(height: 20),
                const Text("Kemarin (3/3)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  // ==========================================
  // STATE 3: TAMPILAN TAMBAH (BARU)
  // ==========================================
  Widget _buildAddReminderView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Icon Header
          const SizedBox(height: 20),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 15)],
            ),
            child: const Icon(Icons.edit_calendar_rounded, size: 40, color: Colors.blue),
          ),
          const SizedBox(height: 30),

          // Form
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama Obat", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.nameC,
                  decoration: _inputDecoration("Contoh: Paracetamol"),
                ),
                const SizedBox(height: 20),
                const Text("Dosis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.doseC,
                  decoration: _inputDecoration("Contoh: 500mg"),
                ),
                const SizedBox(height: 20),
                const Text("Waktu Minum", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => controller.pickTime(Get.context!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                          "${controller.selectedTime.value.hour.toString().padLeft(2, '0')} : ${controller.selectedTime.value.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        const Icon(Icons.access_time_filled, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          // Tombol Simpan
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => controller.saveManualReminder(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 5,
              ),
              child: const Text("SIMPAN PENGINGAT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  Widget _buildMedicineCard({required String name, required List schedules, bool isClickable = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isClickable ? Border.all(color: Colors.blue.withOpacity(0.3)) : null,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.rotate(angle: -0.5, child: const Icon(Icons.medication_outlined, size: 28)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, decoration: TextDecoration.underline)),
                const SizedBox(height: 8),
                ...schedules.map((s) => Text("• ${s['time']} ${s['taken'] ? '✓' : ''}", style: TextStyle(color: Colors.grey[700]))).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String time, int status) {
    return Column(
      children: [
        Row(
          children: [
            if (status == 1) ...[
              const Icon(Icons.check, size: 20, color: Colors.black87),
            ] else if (status == 2) ...[
              const Icon(Icons.close, size: 20, color: Colors.red),
            ] else ...[
              Container(width: 12, height: 4, color: Colors.black87),
              const SizedBox(width: 4),
            ],
            const SizedBox(width: 5),
            Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
        if (status == 2) const Text("Terlewat", style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}