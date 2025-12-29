import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Background Seragam
    final Color bgPage = const Color(0xFFFAFBFF);
    final Color primaryColor = const Color(0xFF2F80ED);

    return Scaffold(
      backgroundColor: bgPage,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hilangkan tombol back karena ini menu utama
        title: const Text(
          'Profil Saya',
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
            // --- 1. KARTU IDENTITAS PASIEN ---
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)], // Biru Gradasi Segar
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F80ED).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Foto Profil dengan Border
                  Container(
                    width: 70, 
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                      image: DecorationImage(
                        image: NetworkImage(controller.userProfile['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // Info Teks
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userProfile['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "No. RM: ${controller.userProfile['rm_number']}",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. MENU PENGATURAN ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Pengaturan Akun", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),

            _buildMenuTile(
              icon: Icons.person_outline_rounded,
              title: "Edit Data Diri",
              onTap: () {},
            ),
            _buildMenuTile(
              icon: Icons.lock_outline_rounded,
              title: "Ganti Kata Sandi",
              onTap: () {},
            ),
            _buildMenuTile(
              icon: Icons.notifications_none_rounded,
              title: "Notifikasi",
              trailing: Switch(
                value: true, 
                onChanged: (val) {}, 
                activeColor: primaryColor
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Bantuan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),

            _buildMenuTile(
              icon: Icons.help_outline_rounded,
              title: "Pusat Bantuan",
              onTap: () {},
            ),
            _buildMenuTile(
              icon: Icons.info_outline_rounded,
              title: "Tentang Aplikasi",
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // --- 3. TOMBOL LOGOUT ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () => controller.logout(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text("KELUAR APLIKASI"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Text("Versi Aplikasi 1.0.0", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION (KONSISTEN) ---
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
          currentIndex: 3, // AKTIF DI PROFIL
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 0) Get.offAllNamed(Routes.HOME);
            if (index == 1) Get.offAllNamed(Routes.MEDICATION);
            if (index == 2) Get.offAllNamed(Routes.APPOINTMENT);
            // Index 3 is current
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

  // --- WIDGET HELPER ---
  Widget _buildMenuTile({
    required IconData icon, 
    required String title, 
    VoidCallback? onTap,
    Widget? trailing
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blueGrey, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}