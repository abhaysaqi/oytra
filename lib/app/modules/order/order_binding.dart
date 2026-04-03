import 'package:get/get.dart';
import '../products/repositories/product_repository.dart';
import '../products/providers/product_provider.dart';
import 'order_controller.dart';
import 'repositories/order_repository.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    // ProductProvider & ProductRepository may already be registered; use
    // Get.put with permanent=false so they're reused if available.
    if (!Get.isRegistered<ProductProvider>()) {
      Get.lazyPut(() => ProductProvider());
    }
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut(() => ProductRepository(Get.find()));
    }
    Get.lazyPut(() => OrderRepository(Get.find()));
    Get.lazyPut(() => OrderController(Get.find()));
  }
}
