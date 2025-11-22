import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Wajib import ini

import 'app/routes/app_pages.dart'; // Sesuaikan dengan lokasi file routes Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // PERHATIKAN: Harus 'GetMaterialApp', BUKAN 'MaterialApp' biasa
    return GetMaterialApp(
      title: "Asisten Kesehatan",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}