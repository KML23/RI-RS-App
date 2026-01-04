import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../appointment/controllers/appointment_controller.dart';

class DokumenController extends GetxController {
  // List untuk menampung file yang diupload
  var uploadedFiles = <Map<String, dynamic>>[].obs;

  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;

  // 1. Fungsi Ambil Foto (Kamera)
  Future<void> pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      String fileName = "Foto_Rontgen_${DateTime.now().hour}${DateTime.now().minute}.jpg";
      uploadedFiles.add({"name": fileName, "type": "img", "path": photo.path});
      
      Get.snackbar("Berhasil", "Foto berhasil ditambahkan", backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  // 2. Fungsi Ambil File (Galeri/File Manager)
  Future<void> pickFileFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String fileName = "Hasil_Lab_${DateTime.now().millisecond}.pdf";
      uploadedFiles.add({"name": fileName, "type": "pdf", "path": image.path});
    }
  }

  // 3. Hapus File dari List
  void removeFile(int index) {
    uploadedFiles.removeAt(index);
  }

  // 4. Kirim Dokumen (Finalisasi)
  void submitDocuments() async {
    if (uploadedFiles.isEmpty) {
      Get.snackbar("Info", "Belum ada dokumen yang diunggah.", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Efek loading
    isLoading.value = false;

    // --- LOGIKA BARU: UPDATE STATUS KE FIRESTORE ---
    if (Get.isRegistered<AppointmentController>()) {
      Get.find<AppointmentController>().updateDocumentStatus();
    }

    Get.back(); // Kembali ke halaman sebelumnya
    Get.snackbar("Sukses", "Dokumen berhasil dikirim ke Dokter", backgroundColor: Colors.green, colorText: Colors.white);
  }
}