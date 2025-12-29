import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../../../routes/app_pages.dart';

class ChatHomeView extends GetView<ChatController> {
  const ChatHomeView({super.key});

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
        actions: [
          IconButton(
            icon: Icon(Icons.mark_chat_read_outlined, color: primaryColor),
            onPressed: () {
              // Fitur tandai semua dibaca (opsional)
            },
          )
        ],
      ),

      body: Column(
        children: [
          // --- 1. SEARCH BAR ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            color: bgPage,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Dokter atau Perawat...",
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

          // --- 2. LIST DOKTER / CHAT ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 5, // Dummy data, nanti pakai controller.chats.length
              itemBuilder: (context, index) {
                // DATA DUMMY (Nanti ganti dengan data real dari Controller/Firebase)
                final List<Map<String, dynamic>> dummyChats = [
                  {
                    "name": "Dr. Andi Setiawan",
                    "role": "Spesialis Penyakit Dalam",
                    "message": "Baik pak, jangan lupa obatnya diminum...",
                    "time": "10:30",
                    "unread": 2,
                    "isOnline": true,
                    "image": "https://i.pravatar.cc/150?img=11" // Ganti asset lokal jika perlu
                  },
                  {
                    "name": "Ns. Siti Aminah",
                    "role": "Perawat Pendamping",
                    "message": "Hasil labnya sudah keluar bu?",
                    "time": "Kemarin",
                    "unread": 0,
                    "isOnline": true,
                    "image": "https://i.pravatar.cc/150?img=5"
                  },
                  {
                    "name": "Dr. Budi Santoso",
                    "role": "Dokter Umum",
                    "message": "Oke siap, terima kasih kembali.",
                    "time": "Senin",
                    "unread": 0,
                    "isOnline": false,
                    "image": "https://i.pravatar.cc/150?img=3"
                  },
                ];

                // Biar list berulang kalau item > 3
                var chat = dummyChats[index % dummyChats.length];

                return _buildChatCard(
                  name: chat['name'],
                  role: chat['role'],
                  message: chat['message'],
                  time: chat['time'],
                  unreadCount: chat['unread'],
                  isOnline: chat['isOnline'],
                  imageUrl: chat['image'],
                );
              },
            ),
          ),
        ],
      ),
      
      // Floating Action Button (Opsional: Mulai Chat Baru)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke pilih kontak baru
        },
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text("Chat Baru"),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildChatCard({
    required String name,
    required String role,
    required String message,
    required String time,
    required int unreadCount,
    required bool isOnline,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Chat Room
        Get.toNamed(Routes.CHAT_ROOM, arguments: {
          'name': name,
          'status': isOnline ? 'Online' : 'Offline',
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          // Border indikator kalau ada pesan belum dibaca
          border: unreadCount > 0 
            ? Border.all(color: Colors.blue.withOpacity(0.3), width: 1)
            : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            // AVATAR AREA
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imageUrl), // Bisa ganti AssetImage
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Indikator Online
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
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

            // TEXT CONTENT AREA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama & Role
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: unreadCount > 0 ? Colors.blue : Colors.grey[400],
                          fontSize: 12,
                          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(color: Colors.blue[300], fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  
                  // Pesan Terakhir
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: unreadCount > 0 ? Colors.black87 : Colors.grey[500],
                            fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      
                      // Badge Unread Count
                      if (unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "$unreadCount",
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}