import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../../../data/models/message_model.dart';

class ChatRoomView extends GetView<ChatController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.isNurseJoined.value
                    ? "Tim Perawat"
                    : "Asisten AI Medis",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (controller.isNurseJoined.value)
                const Text(
                  "• Online (Sinta)",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // --- LIST CHAT AREA ---
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isLast = index == controller.messages.length - 1;

                  return Column(
                    children: [
                      _buildChatBubble(msg),

                      // Logika menampilkan Feedback Option
                      // Muncul hanya jika: Pesan terakhir, Dari AI, dan Perawat BELUM join
                      if (isLast &&
                          msg.sender == ChatSender.ai &&
                          !controller.isNurseJoined.value)
                        _buildFeedbackAI(),
                    ],
                  );
                },
              );
            }),
          ),

          // --- TYPING INDICATOR ---
          Obx(
            () => controller.isTyping.value
                ? Container(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Sedang mengetik...",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // --- INPUT AREA ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: controller.textEditingController,
                        decoration: const InputDecoration(
                          hintText: "Ketik Pesan Anda...",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (val) => controller.sendMessage(val),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => controller.sendMessage(
                      controller.textEditingController.text,
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.send, color: Colors.blue),
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

  // --- WIDGET BUBBLE CHAT ---
  Widget _buildChatBubble(ChatMessage msg) {
    if (msg.sender == ChatSender.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              msg.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Divider(height: 20, thickness: 0.5),
          ],
        ),
      );
    }

    bool isMe = msg.sender == ChatSender.user;
    bool isNurse = msg.sender == ChatSender.nurse;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[600] : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: [
            if (!isMe)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNurse)
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "Sinta (Tim Perawat)",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

            Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                controller.formatTime(msg.time),
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.grey[400],
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET FEEDBACK (UPDATED WITH LOADING STATE) ---
  Widget _buildFeedbackAI() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          const Text(
            "Apakah jawaban ini membantu?",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tombol Ya
              ElevatedButton(
                onPressed: () =>
                    Get.snackbar("Info", "Terima kasih feedbacknya"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Ya"),
              ),
              const SizedBox(width: 10),

              // --- UPDATE START: Tombol dengan Loading State ---
              Obx(() {
                bool isLoading = controller.isConnectingToNurse.value;
                return ElevatedButton(
                  // Jika isLoading, onPressed = null (otomatis disabled)
                  onPressed: isLoading
                      ? null
                      : () => controller.connectToNurse(),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.grey[300], // Warna saat disabled
                    disabledForegroundColor: Colors.grey[600],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(
                      180,
                      40,
                    ), // Ukuran fixed agar tidak goyang
                  ),
                  child: Row(
                    children: [
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      Text(
                        isLoading
                            ? "Menghubungkan..."
                            : "Bicara dengan Perawat",
                      ),
                    ],
                  ),
                );
              }),
              // --- UPDATE END ---
            ],
          ),
        ],
      ),
    );
  }
}
