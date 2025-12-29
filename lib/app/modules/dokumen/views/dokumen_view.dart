import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dokumen_controller.dart';

class DokumenView extends GetView<DokumenController> {
  const DokumenView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Background seragam dengan Home & Fitur Lain
    final Color bgPage = const Color(0xFFFAFBFF);

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
          'Unggah Dokumen',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800, // Font tebal konsisten
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
                  // --- 1. HERO / INFO CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // Gradient Ungu-Biru Muda (Nuansa Digital/Dokumen)
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.indigo.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                          ),
                          child: const Icon(Icons.folder_shared_rounded, color: Colors.indigoAccent, size: 28),
                        ),
                        const SizedBox(width: 15),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dokumen Pendukung",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Lampirkan hasil Lab, Rontgen, atau Resume Medis agar dokter bisa menganalisa lebih baik.",
                                style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  // --- 2. PILIHAN UPLOAD (2 TOMBOL BESAR) ---
                  const Text(
                    "Pilih Metode Upload",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  
                  Row(
                    children: [
                      // Tombol Kamera
                      Expanded(
                        child: _buildUploadOption(
                          label: "Ambil Foto",
                          subLabel: "Pakai Kamera",
                          icon: Icons.camera_alt_rounded,
                          color: Colors.blue,
                          onTap: () => controller.pickFromCamera(),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Tombol Galeri
                      Expanded(
                        child: _buildUploadOption(
                          label: "Pilih File",
                          subLabel: "Dari Galeri/PDF",
                          icon: Icons.photo_library_rounded,
                          color: Colors.orange,
                          onTap: () => controller.pickFileFromGallery(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Divider(thickness: 1, color: Colors.black12),
                  const SizedBox(height: 20),

                  // --- 3. LIST DOKUMEN ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "File Terpilih",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${controller.uploadedFiles.length} File", 
                          style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // List Item
                  Obx(() {
                    if (controller.uploadedFiles.isEmpty) {
                      return _buildEmptyState();
                    }
                    return Column(
                      children: List.generate(controller.uploadedFiles.length, (index) {
                        var file = controller.uploadedFiles[index];
                        return _buildFileCard(file, index);
                      }),
                    );
                  }),
                ],
              ),
            ),
          ),

          // --- 4. BOTTOM ACTION ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
              ],
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
                    backgroundColor: const Color(0xFF2F80ED),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: const Color(0xFF2F80ED).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20, height: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, size: 20),
                            SizedBox(width: 10),
                            Text(
                              "KIRIM DOKUMEN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildUploadOption({
    required String label,
    required String subLabel,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              subLabel,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
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
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Tipe File
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isPdf ? Colors.red.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
              color: isPdf ? Colors.red : Colors.blue,
              size: 26,
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
                  isPdf ? "Dokumen PDF • 2.4 MB" : "Gambar JPEG • 1.2 MB",
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),

          // Tombol Hapus (Merah Soft)
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: Colors.red[300]),
            onPressed: () => controller.removeFile(index),
          ),
        ],
      ),
    );
  }

Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        // --- PERBAIKAN DI SINI ---
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          style: BorderStyle.solid, // Ganti 'dashed' jadi 'solid'
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.upload_file_rounded, size: 40, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(
            "Belum ada dokumen yang dipilih",
            style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}