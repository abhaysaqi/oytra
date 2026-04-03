import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../products/repositories/product_repository.dart';
import 'order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(title: const Text('Place Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Info Card ──────────────────────────────────────────
            _ProductInfoCard(controller: controller),
            const SizedBox(height: 20),

            // ── Quantity Stepper ───────────────────────────────────────────
            _QuantityStepper(controller: controller),
            const SizedBox(height: 20),

            // ── Order Summary ──────────────────────────────────────────────
            _OrderSummaryCard(controller: controller),
            const SizedBox(height: 32),

            // ── Place Order Button ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.placeOrder,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Product Info Card ────────────────────────────────────────────────────────

class _ProductInfoCard extends StatelessWidget {
  final OrderController controller;
  const _ProductInfoCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.thumbnail,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.inventory_2, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 14, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        'MOQ: ${product.moq} units',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quantity Stepper ─────────────────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  final OrderController controller;
  const _QuantityStepper({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quantity',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Decrement button
                _StepButton(
                  icon: Icons.remove,
                  onTap: controller.decrement,
                ),
                const SizedBox(width: 16),
                // Quantity display / manual input
                Expanded(
                  child: Obx(() => TextFormField(
                        key: ValueKey(controller.quantity.value),
                        initialValue: '${controller.quantity.value}',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryColor,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onChanged: (val) {
                          final n = int.tryParse(val);
                          if (n != null && n > 0) {
                            controller.quantity.value = n;
                          }
                        },
                      )),
                ),
                const SizedBox(width: 16),
                // Increment button
                _StepButton(
                  icon: Icons.add,
                  onTap: controller.increment,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  controller.quantity.value < controller.product.moq
                      ? '⚠️ Below MOQ (min: ${controller.product.moq})'
                      : '✅ Meets MOQ requirement',
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.quantity.value < controller.product.moq
                        ? AppTheme.invalidColor
                        : AppTheme.validColor,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

// ─── Order Summary Card ───────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  final OrderController controller;
  const _OrderSummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDealer =
          controller.customerType == CustomerType.dealer;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 12),
              _SummaryRow(
                label: 'Customer Type',
                value: isDealer ? '🏪 Dealer (20% off)' : '🛒 Retail',
                valueColor:
                    isDealer ? AppTheme.dealerColor : AppTheme.retailColor,
              ),
              _SummaryRow(
                label: 'Unit Price',
                value: '₹${controller.unitPrice.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Quantity',
                value: '× ${controller.quantity.value}',
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    '₹${controller.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
