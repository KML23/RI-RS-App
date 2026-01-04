import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';

class AppointmentController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Data Reactive dari Firestore
  var doctorName = "...".obs;
  var appointmentDate = "...".obs;
  var appointmentTime = "...".obs;
  
  // Status Tugas (Reactive)
  var isKuisionerDone = false.obs;
  var isDocumentDone = false.obs;

  var isLoading = true.obs;

  // List Tugas (Dibuat getter agar otomatis update saat status berubah)
  List<Map<String, dynamic>> get preparationList => [
    {
      "type": "done",
      "text": "Puasa makan dan minum (kecuali air putih) mulai jam 10 malam sehari sebelumnya",
      "isLink": true,
    },
    {
      "type": isKuisionerDone.value ? "done" : "pending",
      "title": "Isi Kuisioner Pra-kunjungan",
      "text": "Isi Kuisioner Pra-kunjungan", // Text saat done
      "status": isKuisionerDone.value ? "Selesai" : "Status: Belum di isi",
      "actionText": "[isi sekarang]",
      "route": Routes.KUISIONER,
      "isLink": false,
    },
    {
      "type": isDocumentDone.value ? "done" : "pending",
      "title": "Unggah Dokumen Pendukung",
      "text": "Unggah Dokumen Pendukung", // Text saat done
      "status": isDocumentDone.value ? "Selesai" : "Status: Belum diunggah",
      "actionText": "[isi sekarang]",
      "route": Routes.DOKUMEN,
      "isLink": false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    bindAppointmentStream();
  }

  // --- 1. DENGARKAN DATA DARI FIRESTORE ---
  void bindAppointmentStream() {
    User? user = auth.currentUser;
    if (user != null) {
      // Kita cek dokumen appointment milik user ini
      firestore.collection('appointments').doc(user.uid).snapshots().listen((doc) {
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          doctorName.value = data['doctor_name'] ?? "Dokter Jaga";
          appointmentDate.value = data['date'] ?? "-";
          appointmentTime.value = data['time'] ?? "-";
          
          // Update status tugas
          isKuisionerDone.value = data['is_kuisioner_done'] ?? false;
          isDocumentDone.value = data['is_document_done'] ?? false;
        } else {
          // Kalau belum ada data, kita buat data default (dummy awal) di Firestore
          createDefaultAppointment(user.uid);
        }
        isLoading.value = false;
      });
    }
  }

  // Buat data default jika pengguna baru pertama kali buka
  void createDefaultAppointment(String uid) {
    firestore.collection('appointments').doc(uid).set({
      'doctor_name': 'Dr. Budi, Sp.PD',
      'date': "Jumat, 24 Oktober 2025",
      'time': "10:00 WIB",
      'is_kuisioner_done': false,
      'is_document_done': false,
    });
  }

  // --- 2. UPDATE STATUS TUGAS (Dipanggil dari Controller lain) ---
  
  // Update Kuisioner Jadi Selesai
  void updateKuisionerStatus() async {
    User? user = auth.currentUser;
    if (user != null) {
      await firestore.collection('appointments').doc(user.uid).update({
        'is_kuisioner_done': true
      });
    }
  }

  // Update Dokumen Jadi Selesai
  void updateDocumentStatus() async {
    User? user = auth.currentUser;
    if (user != null) {
      await firestore.collection('appointments').doc(user.uid).update({
        'is_document_done': true
      });
    }
  }
}