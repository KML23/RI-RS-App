import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatRoomView extends GetView<ChatController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil Data dari Halaman Sebelumnya (Arguments)
    final Map<String, dynamic> args = Get.arguments ?? {
      'name': 'Dr. Dokter', 
      'status': 'Online'
    };
    
    final String doctorName = args['name'];
    final String status = args['status'];
    final bool isOnline = status == 'Online';

    final Color bgPage = const Color(0xFFFAFBFF);

    return Scaffold(
      backgroundColor: bgPage,

      // --- 1. HEADER CHAT ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1, // Sedikit shadow biar terpisah dari chat area
        shadowColor: Colors.grey.shade100,
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            // Avatar Kecil di Header
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey),
                  // foregroundImage: NetworkImage('url_foto_jika_ada'),
                ),
                if (isOnline)
                  Positioned(
                    right: 0, 
                    bottom: 0,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.grey, 
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_rounded, color: Colors.blue),
            onPressed: () {
              // Fitur Telepon (Opsional)
              Get.snackbar("Info", "Fitur panggilan suara akan segera hadir.");
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam_rounded, color: Colors.blue),
            onPressed: () {
              // Fitur Video Call (Opsional)
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // --- 2. AREA CHAT (MESSAGES) ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                // Tanggal Pemisah
                _buildDateSeparator("Hari Ini"),
                
                // Pesan Dokter (Kiri)
                _buildMessageBubble(
                  message: "Selamat pagi, Pak. Bagaimana perkembangan nyeri sendinya hari ini?",
                  time: "08:30",
                  isSender: false,
                ),

                // Pesan User (Kanan)
                _buildMessageBubble(
                  message: "Selamat pagi Dok. Alhamdulillah sudah agak mendingan setelah minum obat.",
                  time: "08:32",
                  isSender: true,
                ),

                // Pesan Dokter (Kiri)
                _buildMessageBubble(
                  message: "Syukurlah. Jangan lupa tetap kompres hangat ya kalau masih terasa kaku.",
                  time: "08:33",
                  isSender: false,
                ),
                
                 // Pesan User (Kanan - Panjang)
                _buildMessageBubble(
                  message: "Baik Dok, akan saya lakukan. Nanti sore saya kirim foto hasil tensi darah ya.",
                  time: "08:35",
                  isSender: true,
                ),
              ],
            ),
          ),

          // --- 3. INPUT AREA (BAGIAN BAWAH) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Tombol Tambah (Attachment)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.grey, size: 28),
                  ),
                  
                  // Kolom Ketik
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Tulis pesan...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 10),
                  
                  // Tombol Kirim (Besar & Biru)
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F80ED),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                         // Aksi kirim pesan
                      },
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildDateSeparator(String date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message, 
    required String time, 
    required bool isSender
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 280), // Maksimal lebar balon 70% layar
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF2F80ED) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isSender ? const Radius.circular(20) : const Radius.circular(0), // Ekor balon dokter
            bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(20), // Ekor balon user
          ),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.4, // Spasi baris biar enak dibaca
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: isSender ? Colors.white.withOpacity(0.7) : Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
                if (isSender) ...[
                  const SizedBox(width: 5),
                  const Icon(Icons.done_all_rounded, color: Colors.white70, size: 14),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}