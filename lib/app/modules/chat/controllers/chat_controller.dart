import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/message_model.dart';

class ChatController extends GetxController {
  // --- State Variables ---
  var messages = <ChatMessage>[].obs;
  var textInput = ''.obs;
  
  // Status Logic
  var isNurseJoined = false.obs;
  var isTyping = false.obs;
  
  // STATE BARU: Menangani loading saat request ke perawat
  var isConnectingToNurse = false.obs;

  // --- Controllers ---
  late ScrollController scrollController;
  late TextEditingController textEditingController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    textEditingController = TextEditingController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.onClose();
  }

  // --- Fungsi Kirim Pesan ---
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // 1. Tambah pesan user ke list
    messages.add(ChatMessage(
      text: text,
      sender: ChatSender.user,
      time: DateTime.now(),
    ));
    
    // 2. Bersihkan input & scroll
    textEditingController.clear();
    _scrollToBottom();

    // 3. Tentukan respon (AI atau Perawat)
    if (isNurseJoined.value) {
      _simulateNurseResponse();
    } else {
      _simulateAIResponse(text);
    }
  }

  // --- Logic Utama: Switch ke Perawat dengan Safety Timeout ---
  void connectToNurse() async {
    // Cegah double request
    if (isConnectingToNurse.value) return;

    try {
      // 1. Mulai Loading (UI Button akan disable & berubah teks)
      isConnectingToNurse.value = true;

      // 2. Simulasi Network Call (Delay 3 detik)
      // Di dunia nyata, ini adalah request API/WebSocket connect
      await Future.delayed(const Duration(seconds: 3));

      // (Opsional) Simulasi Random Error untuk mengetes safety logic
      // if (DateTime.now().second % 2 == 0) throw Exception("Server sibuk");

      // 3. Jika sukses
      isNurseJoined.value = true;
      
      messages.add(ChatMessage(
        text: "---- Terhubung dengan Tim Perawat ----",
        sender: ChatSender.system,
        time: DateTime.now(),
      ));
      
      messages.add(ChatMessage(
        text: "Halo Bapak Sandy, nama saya Sinta dari Tim Perawat. Saya sudah membaca percakapan Anda. Ada yang bisa dibantu?",
        sender: ChatSender.nurse,
        time: DateTime.now(),
      ));
      
      _scrollToBottom();

    } catch (e) {
      // 4. Handle Error / Timeout
      Get.snackbar(
        "Gagal Terhubung", 
        "Tim perawat sedang sibuk, silakan coba sesaat lagi.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.TOP
      );
    } finally {
      // 5. SAFETY NET: Apa pun yang terjadi (Sukses/Error),
      // matikan status loading agar tombol kembali aktif/hilang.
      isConnectingToNurse.value = false;
    }
  }

  // --- Simulasi Respon AI ---
void _simulateAIResponse(String query) async {
    isTyping.value = true;
    _scrollToBottom();
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (isClosed) return; 
    isTyping.value = false;

    String response = "";
    String lowerQuery = query.toLowerCase();

    // 1. LOGIKA TRIASE SEDERHANA
    if (lowerQuery.contains("sakit") || lowerQuery.contains("nyeri") || lowerQuery.contains("darah")) {
      response = "Saya mendeteksi keluhan nyeri atau pendarahan. Sebaiknya ini diperiksa oleh tim medis. Silakan tekan tombol 'Bicara dengan Perawat' di bawah untuk terhubung langsung.";
    } 
    else if (lowerQuery.contains("jadwal") || lowerQuery.contains("kapan")) {
      response = "Untuk jadwal kontrol dan minum obat, Anda bisa melihatnya di menu 'Jadwal Obat' atau 'Janji Temu' di halaman depan.";
    }
    else if (lowerQuery.contains("gatal") || lowerQuery.contains("kering")) {
       response = "Rasa gatal ringan pada bekas jahitan adalah bagian normal dari proses penyembuhan. Pastikan area tersebut tetap kering dan bersih.";
    }
    else {
      response = "Maaf, saya kurang mengerti. Bisa jelaskan lebih detail gejalanya? Atau hubungi perawat jika mendesak.";
    }

    messages.add(ChatMessage(
      text: response,
      sender: ChatSender.ai,
      time: DateTime.now(),
    ));
    _scrollToBottom();
  }

  // --- Simulasi Respon Perawat ---
  void _simulateNurseResponse() async {
    isTyping.value = true;
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 3));

    if (isClosed) return;
    isTyping.value = false;
    
    messages.add(ChatMessage(
      text: "Baik, apakah ada kemerahan atau bengkak di sekitar area jahitan? Anda bisa mengirimkan foto jika perlu.",
      sender: ChatSender.nurse,
      time: DateTime.now(),
    ));
    _scrollToBottom();
  }

  // --- Helper Scroll ---
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}