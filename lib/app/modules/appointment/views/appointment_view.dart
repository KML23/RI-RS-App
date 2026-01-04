import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointment_controller.dart';
import '../../../routes/app_pages.dart';

class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    // Background senada dengan Home & Medication
    final Color bgPage = const Color(0xFFFAFBFF);

    return Scaffold(
      backgroundColor: bgPage,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.offAllNamed(Routes.HOME),
        ),
        title: const Text(
          'Persiapan Kunjungan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. TIKET DOKTER (HERO SECTION) ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // Gradasi Teal/Hijau Tosca
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D6A4F), Color(0xFF40916C)], 
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2D6A4F).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20, top: -20,
                    child: CircleAvatar(radius: 50, backgroundColor: Colors.white.withOpacity(0.1)),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label Kecil
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_user_outlined, color: Colors.white, size: 14),
                              SizedBox(width: 5),
                              Text("Terjadwal", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Nama Dokter (Realtime)
                        Text(
                          controller.doctorName.value,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text(
                          "Spesialis Penyakit Dalam",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 25),
                        
                        // Info Waktu (Realtime)
                        Row(
                          children: [
                            _buildTicketInfo(Icons.calendar_month_rounded, "Tanggal", controller.appointmentDate.value),
                            const SizedBox(width: 20),
                            Container(width: 1, height: 40, color: Colors.white24),
                            const SizedBox(width: 20),
                            _buildTicketInfo(Icons.access_time_filled_rounded, "Jam", controller.appointmentTime.value),
                          ],
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            
            // --- 2. JUDUL SECTION ---
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "Daftar Tugas Pasien",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 15),

            // --- 3. LIST TUGAS (CARD STYLE) ---
            Obx(() {
                if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
                
                return Column(
                  children: controller.preparationList.map((item) {
                    return _buildTaskCard(item);
                  }).toList(),
                );
            }),
            
            const SizedBox(height: 20),
            
            // Footer Info
            Center(
              child: Text(
                "Selesaikan tugas di atas agar\npemeriksaan berjalan lancar.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            )
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: 2, // Aktif di Jadwal
          selectedItemColor: const Color(0xFF2D6A4F),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 0) Get.offAllNamed(Routes.HOME);
            if (index == 1) Get.offAllNamed(Routes.MEDICATION);
            if (index == 3) Get.toNamed(Routes.PROFILE);
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

  // --- WIDGET HELPERS ---

  Widget _buildTicketInfo(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> item) {
    bool isDone = item['type'] == 'done';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDone ? Border.all(color: Colors.green.withOpacity(0.3)) : null,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check_rounded : Icons.priority_high_rounded,
              color: isDone ? Colors.green : Colors.orange,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 15),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDone ? item['text'] : item['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDone ? Colors.grey[600] : Colors.black87,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                
                if (!isDone) ...[
                  const SizedBox(height: 6),
                  Text(item['status'], style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  const SizedBox(height: 15),
                  
                  if (item.containsKey('route'))
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(item['route']);
                        },
                        icon: const Icon(Icons.edit_document, size: 16),
                        label: const Text("ISI SEKARANG"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    )
                ],
                
                if (isDone && item['isLink'] == false)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: const [
                        Icon(Icons.thumb_up_alt_outlined, size: 14, color: Colors.green),
                        SizedBox(width: 5),
                        Text("Terima kasih, data sudah diterima.", style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}