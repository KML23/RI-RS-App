import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Warna & Style
    final Color primaryBlue = Color(0xFF007BFF);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4F8),
        elevation: 0,
        // Matikan leading bawaan agar tidak ada batasan lebar yang kaku
        automaticallyImplyLeading: false, 
        // Beri jarak sedikit dari pinggir layar
        titleSpacing: 20, 
        title: Row(
          children: [
            // --- 1. TOMBOL KEMBALI (ICON + TEKS) ---
            // Kita gabung jadi satu GestureDetector agar area kliknya enak
            GestureDetector(
              onTap: () => controller.backButton(),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Agar ukurannya seperlunya saja
                children: [
                  Icon(
                    Icons.arrow_back_ios, 
                    color: Color(0xFF007BFF), // primaryBlue
                    size: 18
                  ),
                  // Tidak perlu SizedBox lebar-lebar, cukup nempel atau dikit aja
                  const SizedBox(width: 2), 
                  Text(
                    "Kembali",
                    style: TextStyle(
                      color: Color(0xFF007BFF), // primaryBlue
                      fontSize: 14,
                      fontWeight: FontWeight.w500 // Sedikit tebal biar enak dibaca
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. JARAK ANTARA KEMBALI & JUDUL ---
            const SizedBox(width: 15), 

            // --- 3. JUDUL HALAMAN ---
            // Bungkus dengan Flexible agar kalau layar kecil teks tidak overflow keluar layar kanan
            Flexible( 
              child: Obx(() => Text(
                "Pendaftaran Akun (${controller.currentStep.value}/2)",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis, // Titik-titik jika kepanjangan
                maxLines: 1,
              )),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              // --- LOGO (Sama di kedua step) ---
              Icon(Icons.medication_liquid, size: 80, color: primaryBlue),
              const SizedBox(height: 10),
              const Text(
                "Asisten Kesehatan Anda",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // --- CONTENT AREA (SWITCHABLE) ---
              Obx(() {
                if (controller.currentStep.value == 1) {
                  return _buildStepOne(primaryBlue);
                } else {
                  return _buildStepTwo(primaryBlue);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ================== STEP 1 WIDGET ==================
  Widget _buildStepOne(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Verifikasi Data Pasien\nUntuk keamanan, kami perlu memverifikasi bahwa Anda adalah pasien kami.",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),

        // Input RM
        const Text("Nomor Rekam Medis :", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.rmC,
          decoration: _inputDecoration("Masukkan Nomor Rekam Medis Anda"),
        ),

        const SizedBox(height: 20),

        // Input Tanggal Lahir
        const Text("Tanggal Lahir", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.dobC,
          readOnly: true, // Tidak bisa diketik manual
          onTap: () => controller.selectDate(Get.context!),
          decoration: _inputDecoration("DD / MM / YYYY").copyWith(
            suffixIcon: Icon(Icons.calendar_month, color: color),
          ),
        ),

        const SizedBox(height: 40),

        // Button Verifikasi
        Center(
          child: SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () => controller.verifyData(),
              style: _buttonStyle(),
              child: const Text("VERIFIKASI"),
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Footer Masuk Disini
        Center(
          child: RichText(
            text: TextSpan(
              text: "Sudah Punya Akun? ",
              style: TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: "Masuk Disini!!",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================== STEP 2 WIDGET ==================
  Widget _buildStepTwo(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pesan Berhasil
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: "Verifikasi Berhasil!!\n"),
              TextSpan(text: "Selamat Datang, \"Bapak Manto\".\n"),
              TextSpan(text: "20221037031147"),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Input Password Baru
        const Text("Buat Password Aplikasi :", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: controller.passC,
          obscureText: controller.isPassHidden.value,
          decoration: _inputDecoration("Minimal 8 Karakter...").copyWith(
            suffixIcon: IconButton(
              icon: Icon(controller.isPassHidden.value ? Icons.visibility_off : Icons.visibility, color: color),
              onPressed: () => controller.isPassHidden.toggle(),
            ),
          ),
        )),

        const SizedBox(height: 20),

        // Input Konfirmasi Password
        const Text("Konfirmasi Password :", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: controller.confirmPassC,
          obscureText: controller.isConfirmHidden.value,
          decoration: _inputDecoration("Ulangi Password Anda").copyWith(
            suffixIcon: IconButton(
              icon: Icon(controller.isConfirmHidden.value ? Icons.visibility_off : Icons.visibility, color: color),
              onPressed: () => controller.isConfirmHidden.toggle(),
            ),
          ),
        )),

        const SizedBox(height: 20),

        // Checkbox Syarat & Ketentuan
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: controller.isTermsAccepted.value,
                activeColor: Colors.black,
                onChanged: (val) => controller.isTermsAccepted.value = val!,
              ),
            )),
            const SizedBox(width: 10),
            Expanded(
              child: const Text(
                "Saya setuju dengan syarat & ketentuan dan kebijakan Privasi aplikasi ini",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        // Button Final Verifikasi
        Center(
          child: SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () => controller.submitRegistration(),
              style: _buttonStyle(),
              child: const Text("VERIFIKASI"),
            ),
          ),
        ),
      ],
    );
  }

  // --- REUSABLE STYLES ---
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14, fontStyle: FontStyle.italic),
      filled: true,
      fillColor: const Color(0xFFE0E0E0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFE0E0E0),
      foregroundColor: Colors.black,
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}