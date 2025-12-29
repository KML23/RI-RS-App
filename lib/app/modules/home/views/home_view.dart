import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilers/app/routes/app_pages.dart';
// import 'package:intl/intl.dart'; // Jika ingin pakai intl, tapi kita pakai manual saja biar tanpa setup locale
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Setup Tanggal Manual (Biar aman tanpa config Locale 'id_ID' di main.dart)
    var now = DateTime.now();
    List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    
    // Format: "Senin, 29 Desember 2025"
    String formattedDate = "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFF), // Background putih kebiruan (sejuk di mata)
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER SECTION (LEBIH PERSONAL & JELAS) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tanggal Hari Ini (Penting buat lansia)
                      Text(
                        formattedDate, 
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Sapaan Besar
                      Obx(() => Text(
                        "Halo, ${controller.userName.value.split(' ')[0]}! 👋", // Ambil nama depan
                        style: const TextStyle(
                          fontSize: 26, 
                          fontWeight: FontWeight.w800, // Tebal biar terbaca jelas
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      )),
                    ],
                  ),
                  // Avatar dengan Border Halus
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.blue.shade100, width: 2),
                      boxShadow: [
                         BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=11'), 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- HERO CARD (PENGINGAT PINTAR) ---
              // Desain: Soft Blue Gradient (Tenang & Terpercaya)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B8EFF), Color(0xFF86A8FF)], 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B8EFF).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "🔔 Pengingat Obat",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Paracetamol 500mg",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // Font besar
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Jadwal: Pukul 14:00 (Siang)",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon Besar Transparan
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.medication_liquid_rounded, size: 32, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // --- MENU GRID (2 KOLOM - BESAR & MUDAH DITEKAN) ---
              const Text(
                "Menu Utama",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // JADI 2 KOLOM AGAR TOMBOL BESAR
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.1, // Kotak sedikit melebar
                ),
                itemCount: controller.menus.length,
                itemBuilder: (context, index) {
                  final menu = controller.menus[index];
                  // Warna Dasar Icon
                  Color baseColor = menu['color'];
                  
                  return GestureDetector(
                    onTap: () => Get.toNamed(menu['route']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        // Efek timbul yang lembut (Soft Shadow)
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon Container Besar (Pastel Background)
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: baseColor.withOpacity(0.1), 
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              menu['icon'],
                              color: baseColor, 
                              size: 32, // Icon diperbesar
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Teks Menu
                          Text(
                            menu['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15, // Ukuran teks pas
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION (DENGAN LABEL TEKS) ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // Shadow ke atas biar kelihatan mengapung elegan
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF6B8EFF), // Warna Aktif Biru Soft
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true, // PENTING: Tampilkan label biar lansia paham
          currentIndex: 0, 
          onTap: (index) {
             // LOGIKA NAVIGASI BARU
             if (index == 1) Get.toNamed(Routes.MEDICATION);
             if (index == 2) Get.toNamed(Routes.APPOINTMENT);
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
}