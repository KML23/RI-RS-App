import 'package:get/get.dart';

class EducationController extends GetxController {
  
  var isDetailOpen = false.obs;
  var selectedGuide = <String, dynamic>{}.obs;

  final List<Map<String, dynamic>> educationList = [
    {
      "id": 1,
      "title": "Perawatan Luka Pasca-Operasi",
      "category": "Medis",
      "duration": "5 Menit",
      "thumbnail_color": 0xFF4FACFE,
      "description": "Panduan lengkap menjaga kebersihan luka agar cepat kering.",
      "steps": [
        {
          "title": "Persiapan Alat",
          "subtitle": "Kassa, NaCl, Plester",
          "description": "Siapkan semua alat di atas meja yang bersih. Cuci tangan dengan sabun.",
        },
        {
          "title": "Membersihkan Luka",
          "subtitle": "Teknik usap yang benar",
          "description": "Usap luka dari arah dalam ke luar menggunakan kassa yang dibasahi NaCl.",
        },
      ]
    },
    {
      "id": 2,
      "title": "Cara Booking Jadwal Dokter",
      "category": "Aplikasi",
      "duration": "2 Menit",
      "thumbnail_color": 0xFFFFA600,
      "description": "Langkah mudah membuat janji temu tanpa antri.",
      "steps": [
        {
          "title": "Pilih Menu Janji Temu",
          "subtitle": "Di halaman utama",
          "description": "Tekan menu 'Janji Temu' berwarna hijau tua di halaman beranda.",
        },
        {
          "title": "Pilih Dokter & Tanggal",
          "subtitle": "Sesuaikan jadwal",
          "description": "Pilih dokter spesialis yang tersedia dan tanggal kunjungan yang diinginkan.",
        },
         {
          "title": "Konfirmasi",
          "subtitle": "Dapatkan kode booking",
          "description": "Setelah konfirmasi, Anda akan mendapatkan QR Code untuk check-in di RS.",
        },
      ]
    },
    {
      "id": 3,
      "title": "Aturan Minum Obat",
      "category": "Edukasi Obat",
      "duration": "3 Menit",
      "thumbnail_color": 0xFF00C853,
      "description": "Memahami arti '3x1 sesudah makan' dan lainnya.",
      "steps": []
    },
    {
      "id": 4,
      "title": "Cara Menggunakan Cek Gejala",
      "category": "Aplikasi",
      "duration": "4 Menit",
      "thumbnail_color": 0xFF6A0572,
      "description": "Deteksi dini kondisi anak menggunakan AI foto.",
      "steps": []
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['autoOpenId'] != null) {
      int idToOpen = Get.arguments['autoOpenId'];
      var guide = educationList.firstWhere((element) => element['id'] == idToOpen, orElse: () => {});
      if (guide.isNotEmpty) openDetail(guide);
    }
  }

  void openDetail(Map<String, dynamic> guide) {
    selectedGuide.value = guide;
    isDetailOpen.value = true;
  }

  // --- PERBAIKAN DI SINI ---
  void closeDetail() {
    isDetailOpen.value = false;
    // JANGAN PAKA selectedGuide.clear(); KARENA AKAN MENGHAPUS DATA ASLI DI LIST
    selectedGuide.value = {}; // Ganti dengan map kosong baru agar data asli aman
  }
}