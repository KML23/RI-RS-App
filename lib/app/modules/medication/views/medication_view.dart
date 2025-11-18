import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/medication_controller.dart';

class MedicationView extends GetView<MedicationController> {
  const MedicationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedicationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MedicationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
