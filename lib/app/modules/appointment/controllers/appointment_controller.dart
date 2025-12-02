import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class AppointmentController extends GetxController {
  final doctorName = "Dr. Budi, Sp.PD";
  final appointmentDate = "Jum'at, 24 Oktober 2025";
  final appointmentTime = "10:00 WIB";

  // List tugas (Reactive)
  final preparationList = <Map<String, dynamic>>[
    {
      "type": "done",
      "text":
          "Puasa makan dan minum (kecuali air putih) mulai jam 10 malam sehari sebelumnya",
      "isLink": true,
    },
    {
      "type": "pending",
      "title": "Isi Kuisioner Pra-kunjungan",
      "status": "Status: Belum di isi",
      "actionText": "[isi sekarang]",
      "route": Routes.KUISIONER,
    },
    {
      "type": "pending", // Ini yang akan kita ubah
      "title": "Unggah Dokumen Pendukung (opsional)",
      "status": "Status: Belum diunggah",
      "actionText": "[isi sekarang]",
      "route": Routes.DOKUMEN,
    },
  ].obs;

  // Fungsi mengubah status Kuisioner jadi Selesai
  void markKuisionerAsDone() {
    int index = preparationList.indexWhere(
      (item) => item['title'] != null && item['title'].contains("Kuisioner"),
    );

    if (index != -1) {
      preparationList[index] = {
        "type": "done",
        "text": "Isi Kuisioner Pra-kunjungan",
        "isLink": false,
      };
      preparationList.refresh();
    }
  }

  // --- FUNGSI BARU: MARK DOCUMENT AS DONE ---
  void markDocumentAsDone() {
    int index = preparationList.indexWhere(
      (item) => item['title'] != null && item['title'].contains("Dokumen"),
    );

    if (index != -1) {
      preparationList[index] = {
        "type": "done",
        "text": "Unggah Dokumen Pendukung",
        "isLink": false,
      };
      preparationList.refresh();
    }
  }
}
