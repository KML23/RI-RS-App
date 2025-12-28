import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'app/routes/app_pages.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
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
        scaffoldBackgroundColor: const Color(0xFFF5F9FC), 
      ),
      
      debugShowCheckedModeBanner: false,
    );
  }
}