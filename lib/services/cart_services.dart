// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:ssd_app/contollers/cart_controller.dart';
import 'package:ssd_app/contollers/product_controller.dart';
import 'package:ssd_app/models/cart_product.dart';
import 'package:ssd_app/consts/constant.dart';
import 'package:ssd_app/models/product.dart';

class CartService {
  final Dio _dio = Dio();

  Future<List<CartProduct>> fetchCartItems(String authToken) async {
    try {
      final response = await _dio.post(
        '${BASE_URL}customer/get-cart',
        data: FormData.fromMap({'type': "ONLINE"}),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        CartController cartController = g.Get.find();
        final List<dynamic> cartDataList = response.data['data']['data'] ?? [];
        cartController.totalPrice.value =
            double.tryParse(response.data['total_amount'].toString()) ?? 0.0;
        final List<CartProduct> cartProducts = cartDataList.map((cartData) {
          return CartProduct.fromJson(cartData);
        }).toList();

        return cartProducts;
      } else {
        throw 'Error fetching cart items: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Error fetching cart items: $error';
    }
  }

  Future<void> insertIntoCart(String authToken, Product product) async {
    try {
      ProductController productController = g.Get.find();
      String slabId = productController.calculateSlabId(1, product);
      final response = await _dio.post(
        '${BASE_URL}customer/add-to-cart',
        data: FormData.fromMap({
          'inventory_id[0]': product.inventoryId,
          'quantity[0]': 1,
          'quantity_count[0]': 1,
          'priceable_quantity[0]': 1,
          'price[0]': slabId.isEmpty
              ? product.sellingPrice
              : product.productSlabs.first.sellingPrice,
          'unit_price[0]': slabId.isEmpty
              ? product.sellingPrice
              : product.productSlabs.first.sellingPrice,
          'product_type[0]': 'PEACE',
          'product_type_id[0]': product.category,
          'unit_quantity[0]': 0.55,
          'slab_id[0]': slabId,
          'type[0]': 'ONLINE'
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw 'Error adding product to cart: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Error adding product to cart: $error';
    }
  }

  Future<void> addToCart(String authToken, CartProduct cartProduct) async {
    ProductController productController = g.Get.find();

    try {
      Product? product =
          await productController.findProduct(cartProduct.productId);
      String slabId =
          productController.calculateSlabId(cartProduct.quantity + 1, product!);
      final response = await _dio.post(
        '${BASE_URL}customer/update-cart',
        data: FormData.fromMap({
          'cart_id': cartProduct.id,
          'quantity': cartProduct.quantity + 1,
          'priceable_quantity': cartProduct.quantity + 1,
          'quantity_count': cartProduct.quantity + 1,
          'slab_id': slabId,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw 'Error adding product to cart: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Error adding product to cart: $error';
    }
  }

  Future<void> removeFromCart(String authToken, CartProduct cartProduct) async {
    ProductController productController = g.Get.find();
    try {
      Product? product =
          await productController.findProduct(cartProduct.productId);
      String slabId =
          productController.calculateSlabId(cartProduct.quantity - 1, product!);
      final response = await _dio.post(
        '${BASE_URL}customer/update-cart',
        data: FormData.fromMap({
          'cart_id': cartProduct.id,
          'quantity': cartProduct.quantity - 1,
          'priceable_quantity': cartProduct.quantity - 1,
          'quantity_count': cartProduct.quantity - 1,
          'slab_id': slabId,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw 'Error adding product to cart: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Error adding product to cart: $error';
    }
  }

  Future<void> deleteFromCart(String authToken, CartProduct product) async {
    try {
      final response = await _dio.post(
        '${BASE_URL}customer/delete-cart',
        data: FormData.fromMap({
          'cart_id': product.id,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
      } else {
        throw 'Error removing product from cart: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response!.data['message'] == 'errors') {
        String errorKey = e.response!.data['errors_keys'][0].toString();
        g.Get.snackbar(
            'Error', e.response!.data['errors'][errorKey][0].toString());
      } else {
        g.Get.snackbar('Error', e.response!.data['message'].toString());
      }
    } catch (error) {
      throw 'Error removing product from cart: $error';
    }
  }
}
