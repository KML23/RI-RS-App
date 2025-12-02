import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // LazyPut: Controller hanya dibuat saat screen diakses, 
    // dan dihapus dari memori saat user keluar dari module chat.
    // Efisiensi memori: O(1) access, automatic disposal.
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}