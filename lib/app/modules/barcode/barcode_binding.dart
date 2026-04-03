import 'package:get/get.dart';
import 'barcode_controller.dart';
import 'repositories/barcode_repository.dart';

class BarcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BarcodeRepository());
    Get.lazyPut(() => BarcodeController(Get.find()));
  }
}
