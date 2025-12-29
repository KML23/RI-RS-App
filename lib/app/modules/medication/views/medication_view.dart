import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medication_controller.dart';
import '../../../routes/app_pages.dart';

class MedicationView extends GetView<MedicationController> {
  const MedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Background sama dengan Home agar seamless
    final Color bgPage = const Color(0xFFFAFBFF);

    return Scaffold(
      backgroundColor: bgPage,

      // --- APP BAR (Clean & Unified) ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80,
        leading: Obx(() {
          // Jika di halaman utama list, tombol back kembali ke Home
          if (controller.viewState.value == 1) {
             return IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
              onPressed: () => Get.offAllNamed(Routes.HOME),
            );
          }
          // Jika di sub-halaman (detail/add), tombol back kembali ke List
          if (controller.viewState.value == 2 || controller.viewState.value == 3) {
             return IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
              onPressed: () => controller.backToList(),
            );
          }
           // Jika di Reminder View, tombol back ke List
          if (controller.viewState.value == 0) {
             return IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
              onPressed: () => controller.backToList(),
            );
          }
          return const SizedBox();
        }),
        title: Obx(() {
          String title = 'Jadwal Obat';
          if (controller.viewState.value == 0) title = 'Pengingat';
          if (controller.viewState.value == 2) title = 'Detail Obat';
          if (controller.viewState.value == 3) title = 'Tambah Baru'; 
          
          return Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w800, // Font tebal konsisten
              fontSize: 18,
            ),
          );
        }),
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
            return _buildAddReminderView(); 
          default:
            return _buildScheduleListView();
        }
      }),

      // --- BOTTOM NAVIGATION (MIMIC HOME STYLE) ---
      // Agar user merasa tidak "tersesat", kita samakan style-nya
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: 1, // Aktif di menu Obat
          selectedItemColor: const Color(0xFF6B8EFF),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 0) Get.offAllNamed(Routes.HOME);
            // Index 1 is current
            if (index == 2) Get.offAllNamed(Routes.APPOINTMENT);
            if (index == 3) {} // Profil
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_rounded, size: 28)),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.medication_rounded, size: 28)),
              label: 'Obat',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.calendar_month_rounded, size: 28)),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_rounded, size: 28)),
              label: 'Profil', 
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // STATE 0: TAMPILAN PENGINGAT (RENOVASI TOTAL)
  // ==========================================
  Widget _buildReminderView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            // Shadow tebal tapi soft (Efek Floating Card)
            boxShadow: [
              BoxShadow(color: Colors.red.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10)),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Animasi (Visual Bell)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active_rounded, color: Colors.redAccent, size: 50),
              ),
              const SizedBox(height: 25),
              
              const Text(
                "Waktunya Minum Obat!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Jangan lupa minum obat agar\nkondisi tetap stabil.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
              
              const SizedBox(height: 35),
              
              // Nama Obat Besar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFF),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.medication_liquid_rounded, color: Colors.blue, size: 30),
                    const SizedBox(width: 15),
                    const Text(
                      "Paracetamol 500mg",
                      style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              
              // Action Buttons (Besar & Jelas)
              Row(
                children: [
                   Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.snoozeReminder(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Tunda 10 Menit", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.markAsTaken(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ECDC4), // Warna Hijau Tosca (Sukses)
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("SUDAH MINUM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
  // STATE 1: TAMPILAN LIST (CLEAN STYLE)
  // ==========================================
  Widget _buildScheduleListView() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Header Tanggal Besar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B8EFF), Color(0xFF86A8FF)], // Senada dengan Home
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: const Color(0xFF6B8EFF).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jadwal Hari Ini", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 5),
                  Text("Senin, 19 Oktober", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.calendar_today_rounded, color: Colors.white),
              )
            ],
          ),
        ),

        const SizedBox(height: 25),
        const Text("Daftar Obat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 15),

        // List Obat dengan Card Style Home
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
        
        // Tombol Tambah (Floating Style)
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () => controller.goToAddReminder(),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Tambah Jadwal Obat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6B8EFF),
              elevation: 0,
              side: const BorderSide(color: Color(0xFF6B8EFF), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STATE 2: TAMPILAN DETAIL (INFO JELAS)
  // ==========================================
  Widget _buildDetailView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Info Obat Besar
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: const Color(0xFF6B8EFF).withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.medication_rounded, size: 40, color: Color(0xFF6B8EFF)),
                ),
                const SizedBox(height: 15),
                const Text("PARACETAMOL 500mg", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                const SizedBox(height: 8),
                Text("Diminum 3x sehari • 1 Tablet", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Warning Card
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.orange),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Minum setelah makan untuk menghindari iritasi lambung.",
                    style: TextStyle(color: Colors.brown, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          // Log Kepatuhan
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Riwayat Minum Obat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 15),
          
          _buildHistoryCard("Hari Ini", [1, 1, 0]),
          const SizedBox(height: 15),
          _buildHistoryCard("Kemarin", [1, 2, 1]),
        ],
      ),
    );
  }

  // ==========================================
  // STATE 3: TAMBAH OBAT (FORM BERSIH)
  // ==========================================
  Widget _buildAddReminderView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nama Obat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.nameC,
                  decoration: _inputDecoration("Contoh: Paracetamol"),
                ),
                const SizedBox(height: 20),
                const Text("Dosis (mg/ml)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.doseC,
                  decoration: _inputDecoration("Contoh: 500mg"),
                ),
                const SizedBox(height: 20),
                const Text("Waktu Pengingat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => controller.pickTime(Get.context!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFBFF),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                          "${controller.selectedTime.value.hour.toString().padLeft(2, '0')} : ${controller.selectedTime.value.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        const Icon(Icons.access_time_rounded, color: Color(0xFF6B8EFF)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => controller.saveManualReminder(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B8EFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                shadowColor: const Color(0xFF6B8EFF).withOpacity(0.4),
              ),
              child: const Text("SIMPAN JADWAL", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      fillColor: const Color(0xFFFAFBFF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF6B8EFF))),
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
        border: isClickable ? Border.all(color: const Color(0xFF6B8EFF).withOpacity(0.3), width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isClickable ? const Color(0xFF6B8EFF).withOpacity(0.1) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medication_liquid_rounded, size: 24, color: isClickable ? const Color(0xFF6B8EFF) : Colors.grey),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  children: schedules.map((s) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text("${s['time']}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      if(s['taken']) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, size: 12, color: Colors.green),
                      ]
                    ],
                  )).toList(),
                ),
              ],
            ),
          ),
          if (isClickable)
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
  
  Widget _buildHistoryCard(String title, List<int> status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusItem("08.00", status[0]),
              _buildStatusItem("14.00", status[1]),
              _buildStatusItem("20.00", status[2]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String time, int status) {
    Color color = Colors.grey;
    IconData icon = Icons.circle_outlined;
    String text = "Belum";

    if (status == 1) { color = Colors.green; icon = Icons.check_circle; text = "Diminum"; }
    if (status == 2) { color = Colors.red; icon = Icons.cancel; text = "Terlewat"; }

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 5),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(text, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}