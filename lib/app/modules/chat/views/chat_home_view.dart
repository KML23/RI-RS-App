import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/chat_controller.dart';
import '../../../routes/app_pages.dart';

class ChatHomeView extends GetView<ChatController> {
  const ChatHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Background Seragam
    final Color bgPage = const Color(0xFFFAFBFF);
    final Color primaryColor = const Color(0xFF2F80ED);

    return Scaffold(
      backgroundColor: bgPage,

      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Konsultasi Medis',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. SEARCH BAR ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            color: bgPage,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari riwayat konsultasi...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // --- 2. JUDUL SECTION ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Chat Aktif",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),

          // --- 3. ACTIVE CHAT CARD (REAL TIME) ---
          // Ini kartu utama yang terhubung ke Firestore
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () {
                // Navigasi ke Chat Room
                Get.toNamed(Routes.CHAT_ROOM, arguments: {
                  'name': 'Tim Medis RS', // Nama default grup
                  'status': 'Online 24 Jam',
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    // Avatar RS / Tim Medis
                    Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.medical_services_rounded, color: primaryColor, size: 30),
                        ),
                        Positioned(
                          right: 0, bottom: 0,
                          child: Container(
                            width: 16, height: 16,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    
                    // Detail Pesan Terakhir
                    Expanded(
                      child: Obx(() {
                        // Logic untuk ambil pesan terakhir
                        String lastMsg = "Mulai konsultasi baru...";
                        String timeStr = "";
                        bool isUnread = false;

                        if (controller.messages.isNotEmpty) {
                          // Karena list di controller descending (terbaru di index 0)
                          var latest = controller.messages.first; 
                          lastMsg = latest['text'];
                          
                          // Format Time
                          if (latest['time'] != null && latest['time'] is Timestamp) {
                             DateTime dt = (latest['time'] as Timestamp).toDate();
                             timeStr = "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
                          }
                          
                          // Simulasi unread (di real app butuh field 'isRead')
                          isUnread = !latest['is_user']; // Kalau pesan terakhir dari dokter, anggap belum dibaca
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tim Medis RS",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    color: isUnread ? primaryColor : Colors.grey[400],
                                    fontSize: 12,
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lastMsg,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isUnread ? Colors.black87 : Colors.grey[500],
                                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isUnread)
                                  Container(
                                    width: 10, height: 10,
                                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  )
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // --- 4. DOKTER JAGA (VISUAL ONLY) ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Dokter Jaga Hari Ini",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: [
                _buildDoctorAvatar("Dr. Budi", "Umum"),
                _buildDoctorAvatar("Dr. Sinta", "Gigi"),
                _buildDoctorAvatar("Ns. Rina", "Perawat"),
                _buildDoctorAvatar("Dr. Andi", "Syaraf"),
              ],
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           // Sama, ke chat room juga
           Get.toNamed(Routes.CHAT_ROOM, arguments: {'name': 'Tim Medis RS', 'status': 'Online'});
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.chat_bubble_outline_rounded),
      ),
    );
  }

  // Helper Visual Dokter Jaga
  Widget _buildDoctorAvatar(String name, String role) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150'), // Dummy Avatar
                fit: BoxFit.cover
              )
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(role, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
      ),
    );
  }
}