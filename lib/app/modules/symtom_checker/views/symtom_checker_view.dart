import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/symtom_checker_controller.dart';

class SymtomCheckerView extends GetView<SymtomCheckerController> {
  const SymtomCheckerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SymtomCheckerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SymtomCheckerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
