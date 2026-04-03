import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/theme/app_theme.dart';
import 'barcode_controller.dart';
import 'models/barcode_result_model.dart';

class BarcodeView extends GetView<BarcodeController> {
  const BarcodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // Manual test input button
          IconButton(
            icon: const Icon(Icons.keyboard),
            tooltip: 'Enter barcode manually',
            onPressed: () => _showManualInputDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        final result = controller.result.value;
        if (result != null) {
          return _ResultPanel(result: result, onRescan: controller.resetScan);
        }
        return _ScannerPanel(controller: controller);
      }),
    );
  }

  void _showManualInputDialog(BuildContext context) {
    final textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Enter Barcode Manually'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'e.g. 1234567890',
            prefixIcon: Icon(Icons.qr_code),
          ),
          keyboardType: TextInputType.text,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.simulateScan(textController.text.trim());
            },
            child: const Text('Scan'),
          ),
        ],
      ),
    );
  }
}

// ─── Camera Scanner Panel ─────────────────────────────────────────────────────

class _ScannerPanel extends StatelessWidget {
  final BarcodeController controller;
  const _ScannerPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Camera feed
        MobileScanner(
          onDetect: (capture) {
            final barcode = capture.barcodes.firstOrNull;
            if (barcode?.rawValue != null) {
              controller.onBarcodeDetected(barcode!.rawValue!);
            }
          },
        ),
        // Overlay
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.accentColor, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // Instructions
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Point camera at a barcode or QR code\nOr use ⌨️ button to enter manually',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Result Panel ─────────────────────────────────────────────────────────────

class _ResultPanel extends StatelessWidget {
  final BarcodeResultModel result;
  final VoidCallback onRescan;
  const _ResultPanel({required this.result, required this.onRescan});

  @override
  Widget build(BuildContext context) {
    final isValid = result.isValid;

    return Container(
      color: AppTheme.surfaceColor,
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Status icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: isValid
                  ? AppTheme.validColor.withOpacity(0.12)
                  : AppTheme.invalidColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isValid ? Icons.check_circle : Icons.cancel,
              size: 72,
              color: isValid ? AppTheme.validColor : AppTheme.invalidColor,
            ),
          ),
          const SizedBox(height: 24),

          // Valid / Invalid label
          Text(
            isValid ? '✅ Valid' : '❌ Invalid',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: isValid ? AppTheme.validColor : AppTheme.invalidColor,
            ),
          ),
          const SizedBox(height: 32),

          // Result card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.qr_code,
                    label: 'Barcode',
                    value: result.rawCode,
                  ),
                  const Divider(height: 24),
                  _InfoRow(
                    icon: Icons.inventory_2,
                    label: 'Product',
                    value: result.productName,
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.category,
                    label: 'Category',
                    value: result.productCategory,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.rule,
                    label: 'Rule',
                    value: isValid
                        ? 'Last digit even → Valid'
                        : 'Last digit odd → Invalid',
                    valueStyle: TextStyle(
                      fontSize: 13,
                      color: isValid ? AppTheme.validColor : AppTheme.invalidColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Scan again button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRescan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Again'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.accentColor),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value, style: valueStyle ?? const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
