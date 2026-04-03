import 'package:get/get.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/products/products_binding.dart';
import '../modules/products/products_view.dart';
import '../modules/order/order_binding.dart';
import '../modules/order/order_view.dart';
import '../modules/barcode/barcode_binding.dart';
import '../modules/barcode/barcode_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: AppRoutes.order,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.barcode,
      page: () => const BarcodeView(),
      binding: BarcodeBinding(),
    ),
  ];
}
