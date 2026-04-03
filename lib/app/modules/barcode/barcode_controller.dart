import 'package:get/get.dart';
import 'models/barcode_result_model.dart';
import 'repositories/barcode_repository.dart';

class BarcodeController extends GetxController {
  final BarcodeRepository _repository;
  BarcodeController(this._repository);

  final Rx<BarcodeResultModel?> result = Rx<BarcodeResultModel?>(null);
  final RxBool isScannerActive = true.obs;

  void onBarcodeDetected(String rawCode) {
    if (rawCode.isEmpty) return;

    // Pause scanner while showing result
    isScannerActive.value = false;
    result.value = _repository.process(rawCode);
  }

  void resetScan() {
    result.value = null;
    isScannerActive.value = true;
  }

  /// For manual/demo input (test without physical camera)
  void simulateScan(String code) => onBarcodeDetected(code);
}
