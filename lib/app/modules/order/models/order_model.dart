import '../../products/models/product_model.dart';
import '../../products/repositories/product_repository.dart';

class OrderModel {
  final ProductModel product;
  final int quantity;
  final double unitPrice;
  final CustomerType customerType;

  OrderModel({
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.customerType,
  });

  double get totalPrice => unitPrice * quantity;
}
