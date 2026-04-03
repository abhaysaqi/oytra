import '../models/product_model.dart';
import '../providers/product_provider.dart';

enum CustomerType { dealer, retail }

class ProductRepository {
  final ProductProvider _provider;

  ProductRepository(this._provider);

  /// Dealer gets 20% discount; Retail pays full price.
  double getPriceForCustomer(ProductModel product, CustomerType type) {
    return type == CustomerType.dealer ? product.price * 0.80 : product.price;
  }

  Future<List<ProductModel>> getProducts() => _provider.fetchProducts();
}
