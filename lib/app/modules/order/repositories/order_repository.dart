import '../../products/models/product_model.dart';
import '../../products/repositories/product_repository.dart';
import '../models/order_model.dart';

/// Result of MOQ validation.
class OrderValidationResult {
  final bool isValid;
  final String? errorMessage;
  const OrderValidationResult({required this.isValid, this.errorMessage});
}

class OrderRepository {
  final ProductRepository _productRepository;
  OrderRepository(this._productRepository);

  OrderValidationResult validateOrder(ProductModel product, int quantity) {
    if (quantity <= 0) {
      return const OrderValidationResult(
        isValid: false,
        errorMessage: 'Quantity must be greater than zero.',
      );
    }
    if (quantity < product.moq) {
      return OrderValidationResult(
        isValid: false,
        errorMessage:
            'Minimum order quantity for "${product.title}" is ${product.moq} units.',
      );
    }
    return const OrderValidationResult(isValid: true);
  }

  OrderModel createOrder(
    ProductModel product,
    int quantity,
    CustomerType customerType,
  ) {
    final unitPrice = _productRepository.getPriceForCustomer(product, customerType);
    return OrderModel(
      product: product,
      quantity: quantity,
      unitPrice: unitPrice,
      customerType: customerType,
    );
  }
}
