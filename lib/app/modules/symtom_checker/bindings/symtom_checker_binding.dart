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


//Hilma Salman Maulana (202210370311160)