import 'package:get/get.dart';

import '../controllers/kuisioner_controller.dart';

class KuisionerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KuisionerController>(
      () => KuisionerController(),
    );
  }
}
