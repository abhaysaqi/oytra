class BarcodeResultModel {
  final String rawCode;
  final bool isValid;
  final String productName;
  final String productCategory;

  BarcodeResultModel({
    required this.rawCode,
    required this.isValid,
    required this.productName,
    required this.productCategory,
  });
}
