import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:ssd_app/consts/constant.dart';
import 'package:ssd_app/models/product.dart';

class ProductService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchFeaturedProducts(String authToken) async {
    try {
      final response = await _dio.post(
        '${BASE_URL}customer/find-product-all-v8',
        data: FormData.fromMap({
          'online': true,
          'limit': 20,
          'page': 1,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productDataList = response.data['data']['data'];

        final mappedProducts = productDataList.map((productData) {
          return Product.fromJson(productData);
        }).toList();

        return mappedProducts;
      } else {
        throw 'Error fetching featured products: ${response.statusCode}';
      }
    } on DioException catch (e) {
      g.Get.snackbar("Error", e.response!.data['message'].toString());
    } catch (error) {
      throw 'Error fetching featured products: $error';
    }
    return [];
  }

  Future<Product?> findProduct(String authToken, int productId) async {
    try {
      final response = await _dio.post(
        '${BASE_URL}customer/find-product-all-v8',
        data: FormData.fromMap({
          'online': true,
          'product_id': productId,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final productData = response.data['data']['data'][0];
        final mappedProduct = Product.fromJson(productData);
        return mappedProduct;
      } else {
        throw 'Error fetching product: ${response.statusCode}';
      }
    } on DioException catch (e) {
      g.Get.snackbar("Error", e.response!.data['message'].toString());
    } catch (error) {
      throw 'Error fetching product: $error';
    }
    return null;
  }

  Future<List<Product>> fetchProductsByCategory(
      String authToken, int categoryId) async {
    try {
      final response = await _dio.post(
        '${BASE_URL}customer/find-product-all-v8',
        data: FormData.fromMap({
          'category': categoryId,
          'online': true,
          'page': 1,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productDataList = response.data['data']['data'];

        final mappedProducts = productDataList.map((productData) {
          return Product.fromJson(productData);
        }).toList();

        return mappedProducts;
      } else {
        throw 'Error fetching featured products: ${response.statusCode}';
      }
    } on DioException catch (e) {
      g.Get.snackbar("Error", e.response!.data['message'].toString());
    } catch (error) {
      throw 'Error fetching featured products: $error';
    }
    return [];
  }

  Future<List<Product>> fetchAllProducts(String authToken, int page) async {
    try {
      final response = await _dio.post(
        '${BASE_URL}customer/find-product-all-v8',
        data: FormData.fromMap({
          'online': true,
          'limit': 20,
          'page': page,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productDataList = response.data['data']['data'];

        final mappedProducts = productDataList.map((productData) {
          return Product.fromJson(productData);
        }).toList();

        return mappedProducts;
      } else {
        throw 'Error fetching featured products: ${response.statusCode}';
      }
    } on DioException catch (e) {
      g.Get.snackbar("Error", e.response!.data['message'].toString());
    } catch (error) {
      throw 'Error fetching featured products: $error';
    }
    return [];
  }
}
