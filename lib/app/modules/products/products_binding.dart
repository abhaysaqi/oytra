import 'package:get/get.dart';
import '../../core/network/connectivity_service.dart';
import 'products_controller.dart';
import 'providers/product_provider.dart';
import 'repositories/product_repository.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductProvider());
    Get.lazyPut(() => ProductRepository(Get.find()));
    Get.lazyPut(() => ConnectivityService());
    Get.lazyPut(() => ProductsController(Get.find(), Get.find()));
  }
}
