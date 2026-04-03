import 'package:get/get.dart';
import '../../core/network/connectivity_service.dart';
import 'models/product_model.dart';
import 'repositories/product_repository.dart';

class ProductsController extends GetxController {
  final ProductRepository _repository;
  final ConnectivityService _connectivity;

  ProductsController(this._repository, this._connectivity);

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<CustomerType> customerType = CustomerType.retail.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final connected = await _connectivity.isConnected();
    if (!connected) {
      errorMessage.value = 'No internet connection. Please check your network.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _repository.getProducts();
      products.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to load products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void setCustomerType(CustomerType type) => customerType.value = type;

  double getPriceFor(ProductModel product) =>
      _repository.getPriceForCustomer(product, customerType.value);
}
