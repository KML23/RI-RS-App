import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../controllers/chat_controller.dart';

class ChatRoomView extends GetView<ChatController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil Data dari Halaman Sebelumnya (Arguments)
    final Map<String, dynamic> args = Get.arguments ?? {
      'name': 'Tim Medis', 
      'status': 'Online'
    };
    
    final String doctorName = args['name'];
    
    final Color bgPage = const Color(0xFFFAFBFF);

    return Scaffold(
      backgroundColor: bgPage,

      // --- 1. HEADER CHAT ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.support_agent_rounded, color: Colors.blue),
                ),
                Positioned(
                  right: 0, bottom: 0,
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
                  ),
                  const Text(
                    "Online",
                    style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // --- 2. AREA CHAT (REAL TIME) ---
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    "Mulai konsultasi dengan Tim Medis...", 
                    style: TextStyle(color: Colors.grey[400])
                  ),
                );
              }
              
              return ListView.builder(
                reverse: true, // Biar pesan baru muncul di bawah (tapi listnya dibalik)
                padding: const EdgeInsets.all(20),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  var msg = controller.messages[index];
                  
                  // Format Waktu
                  String timeStr = "";
                  if (msg['time'] != null && msg['time'] is Timestamp) {
                     DateTime dt = (msg['time'] as Timestamp).toDate();
                     timeStr = "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
                  }

                  return _buildMessageBubble(
                    message: msg['text'],
                    time: timeStr,
                    isSender: msg['is_user'], // True = User (Kanan)
                  );
                },
              );
            }),
          ),

          // --- 3. INPUT AREA ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.grey, size: 28),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: controller.textEditingController,
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
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F80ED),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                         controller.sendMessage(controller.textEditingController.text);
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

  Widget _buildMessageBubble({
    required String message, 
    required String time, 
    required bool isSender
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF2F80ED) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isSender ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(20),
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
                height: 1.4,
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