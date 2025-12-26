import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; 
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Color(0xFF007BFF);
    final Color bgInput = Color(0xFFE0E0E0); 

    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- 1. LOGO SECTION ---
              Icon(
                Icons.medication_liquid, 
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
                // PERBAIKAN: Menggunakan rmInputC (bukan emailC)
                controller: controller.rmInputC, 
                decoration: InputDecoration(
                  hintText: "Masukkan Nomor Rekam Medis Anda",
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
                ),
              ),

              const SizedBox(height: 20),

              // --- 4. INPUT PASSWORD ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pasword :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: controller.passC,
                  obscureText: controller.isPasswordHidden.value, 
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off 
                            : Icons.visibility, 
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

              // --- 6. BUTTON MASUK (DENGAN LOADING) ---
              Obx(() => SizedBox(
                width: 200, 
                height: 50,
                child: ElevatedButton(
                  // Matikan tombol jika sedang loading
                  onPressed: controller.isLoading.value ? null : () => controller.login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE0E0E0), 
                    foregroundColor: Colors.black, 
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  // Ganti teks dengan loading spinner jika sedang proses
                  child: controller.isLoading.value 
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: primaryBlue))
                    : const Text(
                        "MASUK",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                ),
              )),

              const SizedBox(height: 60),

              // --- 7. FOOTER ---
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
                        decoration: TextDecoration.underline, 
                      ),
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