import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController extends GetxController {
  // Firebase Setup
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Variables
  var messages = <Map<String, dynamic>>[].obs; // List Pesan Real-time
  var textInput = ''.obs;
  var isLoading = true.obs;

  late TextEditingController textEditingController;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    
    // Langsung dengarkan chat saat masuk room
    bindChatStream();
  }

  // --- 1. DENGARKAN PESAN (STREAM) ---
  void bindChatStream() {
    User? user = auth.currentUser;
    if (user != null) {
      // Masuk ke: chats -> [UID_USER] -> messages
      // Diurutkan berdasarkan waktu (descending: biar yang baru di bawah nanti kita balik di UI)
      firestore
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .orderBy('timestamp', descending: true) 
          .snapshots()
          .listen((snapshot) {
        
        var processedMsgs = snapshot.docs.map((doc) {
          var data = doc.data();
          return {
            "text": data['text'] ?? "",
            "is_user": data['is_user'] ?? true, // True = Kanan, False = Kiri
            "time": data['timestamp'] ?? Timestamp.now(),
          };
        }).toList();

        messages.assignAll(processedMsgs);
        isLoading.value = false;
        
      }, onError: (e) {
        print("Error chat stream: $e");
      });
    }
  }

  // --- 2. KIRIM PESAN (SEND) ---
  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    User? user = auth.currentUser;
    if (user == null) return;

    // Bersihkan input dulu biar responsif
    textEditingController.clear();

    try {
      // Kirim ke Firestore
      await firestore
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add({
        "text": text,
        "is_user": true, // Ini pesan dari User (Pasien)
        "timestamp": FieldValue.serverTimestamp(),
        "sender_email": user.email,
      });
      
      // Auto-scroll ke bawah (opsional, karena biasanya ListView reversed sudah handle)
      
      // --- SIMULASI BALASAN DOKTER (OPSIONAL BIAR GAK SEPI) ---
      // Nanti di dunia nyata, bagian ini dihapus karena Dokter beneran yang balas lewat Admin Panel
      _simulateDoctorReply(user.uid);

    } catch (e) {
      Get.snackbar("Gagal", "Pesan tidak terkirim: $e");
    }
  }

  // Simulasi Balasan Otomatis (Hanya untuk Demo)
  void _simulateDoctorReply(String uid) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Cek dulu jumlah pesan biar gak spamming
    if (messages.length < 3) { 
       await firestore
          .collection('chats')
          .doc(uid)
          .collection('messages')
          .add({
        "text": "Halo, ada keluhan apa yang bisa kami bantu hari ini?",
        "is_user": false, // False = Pesan Dokter
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  void onClose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}