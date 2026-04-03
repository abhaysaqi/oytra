import '../../../core/utils/barcode_validator.dart';
import '../models/barcode_result_model.dart';

/// Dummy product catalogue used for barcode ↔ product mapping.
const _productCatalogue = [
  {'name': 'Wireless Headphones', 'category': 'Electronics'},
  {'name': 'Laptop Stand', 'category': 'Accessories'},
  {'name': 'USB-C Hub', 'category': 'Electronics'},
  {'name': 'Mechanical Keyboard', 'category': 'Peripherals'},
  {'name': 'LED Desk Lamp', 'category': 'Lighting'},
  {'name': 'Ergonomic Chair', 'category': 'Furniture'},
  {'name': 'Noise Cancelling Earbuds', 'category': 'Electronics'},
  {'name': 'Smart Watch', 'category': 'Wearables'},
  {'name': 'Webcam 4K', 'category': 'Electronics'},
  {'name': 'Portable SSD 1TB', 'category': 'Storage'},
];

class BarcodeRepository {
  /// Processes a raw barcode string and returns a [BarcodeResultModel].
  BarcodeResultModel process(String rawCode) {
    final valid = isBarcodeValid(rawCode);

    // Map barcode → product using a hash so the same code always gives
    // the same product name, regardless of validity.
    final digits = rawCode.replaceAll(RegExp(r'[^0-9]'), '');
    final hash = digits.isEmpty
        ? rawCode.hashCode.abs()
        : int.parse(digits) % _productCatalogue.length;
    final index = hash % _productCatalogue.length;
    final entry = _productCatalogue[index];

    return BarcodeResultModel(
      rawCode: rawCode,
      isValid: valid,
      productName: entry['name']!,
      productCategory: entry['category']!,
    );
  }
}
