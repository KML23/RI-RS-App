import 'package:get/get.dart';

import '../controllers/symtom_checker_controller.dart';

class SymtomCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SymtomCheckerController>(
      () => SymtomCheckerController(),
    );
  }
}
