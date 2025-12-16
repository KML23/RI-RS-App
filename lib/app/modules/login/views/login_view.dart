import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Diperlukan untuk TapGestureRecognizer
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna utama biru sesuai logo (sesuaikan hex code jika ada guideline spesifik)
    final Color primaryBlue = Color(0xFF007BFF);
    final Color bgInput = Color(0xFFE0E0E0); // Abu-abu muda untuk input

    return Scaffold(
      // Warna background agak kebiruan/putih sesuai gambar
      backgroundColor: Color(0xFFF0F4F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- 1. LOGO SECTION ---
              // Saya pakai Icon sebagai placeholder, nanti bisa diganti Image.asset
              Icon(
                Icons.medication_liquid, // Icon representasi medis
                size: 80,
                color: primaryBlue,
              ),
              const SizedBox(height: 10),
              const Text(
                "Asisten Kesehatan Anda",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 50),

              // --- 2. HEADLINE ---
              const Text(
                "Selamat Datang Kembali\nSilahkan masuk untuk melanjutkan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 40),

              // --- 3. INPUT REKAM MEDIS ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nomor Rekam Medis :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailC,
                decoration: InputDecoration(
                  hintText: "Masukkan Nomor Rekam Medis Anda",
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                  filled: true,
                  fillColor: bgInput,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded pills
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- 4. INPUT PASSWORD (DENGAN OBX) ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pasword :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              // Menggunakan Obx karena obscureText berubah-ubah
              Obx(
                () => TextField(
                  controller: controller.passC,
                  obscureText:
                      controller.isPasswordHidden.value, // Status hide/show
                  decoration: InputDecoration(
                    hintText: "Masukkan Password Anda",
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    filled: true,
                    fillColor: bgInput,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    // Icon Mata (Visibility Toggle)
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons
                                  .visibility_off // Icon mata silang
                            : Icons.visibility, // Icon mata terbuka
                        color: primaryBlue,
                      ),
                      onPressed: () {
                        controller.togglePasswordVisibility();
                      },
                    ),
                  ),
                ),
              ),

              // --- 5. FORGOT PASSWORD ---
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Lupa Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- 6. BUTTON MASUK ---
              SizedBox(
                width: 200, // Lebar tombol tidak full, sesuai gambar
                height: 50,
                child: ElevatedButton(
                  onPressed: () => controller.login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE0E0E0), // Warna tombol abu-abu
                    foregroundColor: Colors.black, // Warna teks
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "MASUK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // --- 7. FOOTER (DAFTAR DISINI) ---
              RichText(
                text: TextSpan(
                  text: "Belum Punya Akun? ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Daftar Disini!!",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // Garis bawah
                      ),
                      // Navigasi ke Register
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => controller.goToRegister(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
