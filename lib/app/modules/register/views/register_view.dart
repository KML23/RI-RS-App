import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4F8),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => controller.backButton(),
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF007BFF), 
                    size: 18,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "Kembali",
                    style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Obx(
                () => Text(
                  "Pendaftaran Akun (${controller.currentStep.value}/2)",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Icon(Icons.medication_liquid, size: 80, color: primaryBlue),
              const SizedBox(height: 10),
              const Text(
                "Asisten Kesehatan Anda",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

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

        const Text(
          "Nomor Rekam Medis :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.rmC,
          decoration: _inputDecoration("Masukkan Nomor Rekam Medis Anda"),
        ),

        const SizedBox(height: 20),

        const Text(
          "Tanggal Lahir",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.dobC,
          readOnly: true, 
          onTap: () => controller.selectDate(Get.context!),
          decoration: _inputDecoration(
            "DD / MM / YYYY",
          ).copyWith(suffixIcon: Icon(Icons.calendar_month, color: color)),
        ),

        const SizedBox(height: 40),

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
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: "Verifikasi Berhasil!!\n"),
              // Kita tampilkan RM yang baru diinput di step 1
              TextSpan(text: "Nomor RM: ${controller.rmC.text}"), 
            ],
          ),
        ),
        const SizedBox(height: 30),

        const Text(
          "Buat Password Aplikasi :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: controller.passC,
            obscureText: controller.isPassHidden.value,
            decoration: _inputDecoration("Minimal 8 Karakter...").copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPassHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: color,
                ),
                onPressed: () => controller.isPassHidden.toggle(),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Konfirmasi Password :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: controller.confirmPassC,
            obscureText: controller.isConfirmHidden.value,
            decoration: _inputDecoration("Ulangi Password Anda").copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isConfirmHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: color,
                ),
                onPressed: () => controller.isConfirmHidden.toggle(),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: controller.isTermsAccepted.value,
                  activeColor: Colors.black,
                  onChanged: (val) => controller.isTermsAccepted.value = val!,
                ),
              ),
            ),
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

        // --- BUTTON FINAL DENGAN LOADING ---
        Center(
          child: Obx(() => SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.submitRegistration(),
              style: _buttonStyle(),
              child: controller.isLoading.value 
                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Text("DAFTAR SEKARANG"),
            ),
          )),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
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