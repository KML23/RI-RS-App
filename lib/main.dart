import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import konfigurasi Firebase Anda
import 'app/routes/app_pages.dart';

void main() async {
  // 1. Pastikan binding Flutter terinisialisasi sebelum kode asynchronous
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase sesuai platform (Android/iOS/Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Jalankan Aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Asisten Kesehatan",
      
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F9FC), // Background default
      ),
      
      debugShowCheckedModeBanner: false,
    );
  }
}