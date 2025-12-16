import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepByStepView extends StatelessWidget {
  final Map<String, dynamic> stepData;

  const StepByStepView({super.key, required this.stepData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: Text(
          stepData['title'],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: const [
                SizedBox(width: 15),
                Icon(Icons.arrow_back_ios, color: Colors.blue, size: 18),
                Text(
                  "Kembali",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Langkah 1 dari 1",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(Icons.gif, size: 50, color: Colors.grey),
                  Positioned(
                    bottom: 20,
                    child: Text(
                      "(Animasi GIF)",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              stepData['description'] ??
                  "Ikuti instruksi sesuai gambar di atas.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar("Info", "Ini langkah pertama");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text("< Prev"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text("Next >"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
