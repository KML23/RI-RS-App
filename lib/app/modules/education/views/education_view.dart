import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/education_controller.dart';
import 'step_by_step_view.dart';

class EducationView extends GetView<EducationController> {
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Obx(() {
          if (controller.isDetailOpen.value) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
              onPressed: () => controller.closeDetail(),
            );
          } else {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
              onPressed: () => Get.back(),
            );
          }
        }),
        title: Obx(() => Text(
          controller.isDetailOpen.value ? 'Detail Panduan' : 'Pusat Panduan',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isDetailOpen.value) {
          return _buildDetailView();
        } else {
          return _buildListView();
        }
      }),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.educationList.length,
      itemBuilder: (context, index) {
        final item = controller.educationList[index];
        return GestureDetector(
          onTap: () => controller.openDetail(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80, height: 100,
                  decoration: BoxDecoration(
                    color: Color(item['thumbnail_color'] ?? 0xFF000000),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Icon(
                      item['category'] == 'Aplikasi' ? Icons.settings_suggest : Icons.play_circle_fill,
                      color: Colors.white, size: 30
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['category'] ?? "Umum", style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 10, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(item['duration'] ?? "0 mnt", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        Text(item['description'] ?? "", style: TextStyle(color: Colors.grey[600], fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailView() {
    final guide = controller.selectedGuide;
    final steps = guide['steps'] as List? ?? [];
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Color(guide['thumbnail_color'] ?? 0xFFEEEEEE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  guide['category'] == 'Aplikasi' ? Icons.touch_app : Icons.play_circle_outline, 
                  size: 60, color: Colors.white
                ),
                const SizedBox(height: 10),
                Text(guide['title'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("LANGKAH - LANGKAH", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
                const Divider(thickness: 1, height: 30),

                if (steps.isEmpty)
                   const Center(child: Padding(
                     padding: EdgeInsets.only(top: 20),
                     child: Text("Konten detail akan segera tersedia.", style: TextStyle(color: Colors.grey)),
                   ))
                else
                  ...steps.map((step) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => StepByStepView(stepData: step)); 
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F2F5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.arrow_forward, color: Colors.white),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(step['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text(step['subtitle'] ?? "Klik untuk detail", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}