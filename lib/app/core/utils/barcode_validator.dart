/// Returns true if [barcode] is valid (last numeric digit is even).
bool isBarcodeValid(String barcode) {
  // Extract digits from the barcode string
  final digits = barcode.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return false;
  final lastDigit = int.parse(digits[digits.length - 1]);
  return lastDigit % 2 == 0;
}
