import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../products/models/product_model.dart';
import '../products/repositories/product_repository.dart';
import 'models/order_model.dart';
import 'repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository;

  OrderController(this._repository);

  late final ProductModel product;
  late final CustomerType customerType;

  final RxInt quantity = 1.obs;
  final Rx<OrderModel?> confirmedOrder = Rx<OrderModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Arguments: [ProductModel, CustomerType]
    final args = Get.arguments as List<dynamic>;
    product = args[0] as ProductModel;
    customerType = args[1] as CustomerType;
    // Start with MOQ as default quantity
    quantity.value = product.moq;
  }

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  double get unitPrice =>
      _repository.createOrder(product, quantity.value, customerType).unitPrice;

  double get totalPrice => unitPrice * quantity.value;

  void placeOrder() {
    final validation = _repository.validateOrder(product, quantity.value);
    if (!validation.isValid) {
      Get.snackbar(
        '❌ Order Rejected',
        validation.errorMessage!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD50000),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    confirmedOrder.value =
        _repository.createOrder(product, quantity.value, customerType);

    Get.dialog(
      _OrderConfirmationDialog(order: confirmedOrder.value!),
      barrierDismissible: false,
    );
  }
}

// Inline confirmation dialog (no extra route needed)
class _OrderConfirmationDialog extends StatelessWidget {
  final OrderModel order;
  const _OrderConfirmationDialog({required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF00C853), size: 28),
          SizedBox(width: 8),
          Text('Order Confirmed!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Row('Product', order.product.title),
          _Row('Customer',
              order.customerType == CustomerType.dealer ? 'Dealer' : 'Retail'),
          _Row('Unit Price', '₹${order.unitPrice.toStringAsFixed(2)}'),
          _Row('Quantity', '${order.quantity}'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              Text(
                '₹${order.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
