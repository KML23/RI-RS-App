import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dokumen_controller.dart';

class DokumenView extends GetView<DokumenController> {
  const DokumenView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgPage = const Color(0xFFF5F9FC);
    final Color primaryBlue = const Color(0xFF2F80ED);

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: bgPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Unggah Dokumen',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- INSTRUCTION HEADER ---
                  Text(
                    "Unggah hasil lab, rontgen, atau resume medis dari klinik lain",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "(Format: PDF, JPG, PNG)",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),

                  const SizedBox(height: 25),

                  // --- ACTION BUTTONS ROW ---
                  Row(
                    children: [
                      // Tombol 1: File (Biru)
                      Expanded(
                        child: _buildUploadButton(
                          label: "Pilih file dari ponsel",
                          icon: Icons.description_outlined,
                          color: primaryBlue,
                          isOutline: false,
                          onTap: () => controller.pickFileFromGallery(),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // --- PERUBAHAN DI SINI ---
                      // Tombol 2: Kamera (Sekarang Biru Solid)
                      Expanded(
                        child: _buildUploadButton(
                          label: "Ambil foto dokumen",
                          icon: Icons.camera_alt_outlined,
                          color: primaryBlue, // Warna Biru
                          isOutline: false, // Solid, bukan outline
                          onTap: () => controller.pickFromCamera(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 15),

                  // --- UPLOADED LIST HEADER ---
                  Obx(
                    () => Text(
                      "Dokumen Terunggah (${controller.uploadedFiles.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- LIST DOKUMEN ---
                  Obx(() {
                    if (controller.uploadedFiles.isEmpty) {
                      return _buildEmptyState();
                    }
                    return Column(
                      children: List.generate(controller.uploadedFiles.length, (
                        index,
                      ) {
                        var file = controller.uploadedFiles[index];
                        return _buildFileCard(file, index);
                      }),
                    );
                  }),
                ],
              ),
            ),
          ),

          // --- SUBMIT BUTTON AREA ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.black12, width: 0.5),
              ),
            ),
            child: Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitDocuments(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Kirim Dokumen",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: BUTTON UPLOAD ---
  Widget _buildUploadButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isOutline,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: isOutline ? Colors.white : color,
          borderRadius: BorderRadius.circular(12),
          border: isOutline ? Border.all(color: Colors.grey.shade300) : null,
          boxShadow: [
            BoxShadow(
              color: isOutline
                  ? Colors.grey.withOpacity(0.1)
                  : color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isOutline ? Colors.black87 : Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isOutline ? Colors.black87 : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard(Map<String, dynamic> file, int index) {
    bool isPdf = file['type'] == 'pdf';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Tipe File
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPdf
                  ? Colors.red.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf : Icons.image,
              color: isPdf ? Colors.red : Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),

          // Nama File
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  isPdf ? "Dokumen PDF" : "Gambar JPEG",
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),

          // Tombol Hapus
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => controller.removeFile(index),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: EMPTY STATE ---
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.folder_open, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text("Belum ada dokumen", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
