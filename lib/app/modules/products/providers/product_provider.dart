import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductProvider {
  final Dio _dio = DioClient().dio;

  /// Fetches up to [limit] products from DummyJSON.
  Future<List<ProductModel>> fetchProducts({int limit = 20}) async {
    final response = await _dio.get('/products', queryParameters: {'limit': limit});
    final List<dynamic> data = response.data['products'] as List<dynamic>;
    return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
