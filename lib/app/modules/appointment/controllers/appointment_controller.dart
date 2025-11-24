import 'package:get/get.dart';

class AppointmentController extends GetxController {
  // Data Dokter & Jadwal
  final doctorName = "Dr. Budi, Sp.PD";
  final appointmentDate = "Jum'at, 24 Oktober 2025";
  final appointmentTime = "10:00 WIB";

  // Data List Persiapan (Tugas)
  // type: 'done' (sudah check), 'pending' (belum, butuh aksi)
  final preparationList = [
    {
      "type": "done",
      "text":
          "Puasa makan dan minum (kecuali air putih) mulai jam 10 malam sehari sebelumnya",
      "isLink": true, // Untuk style text biru garis bawah
    },
    {
      "type": "pending",
      "title": "Isi Kuisioner Pra-kunjungan",
      "status": "Status: Belum di isi",
      "actionText": "[isi sekarang]",
    },
    {
      "type": "pending",
      "title": "Unggah Dokumen Pendukung (opsional)",
      "status": "Status: Belum diunggah",
      "actionText": "[isi sekarang]",
    },
  ].obs;
}
