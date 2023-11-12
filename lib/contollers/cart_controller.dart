// ignore_for_file: avoid_print
import 'package:get/get.dart';
import 'package:ssd_app/contollers/product_controller.dart';
import 'package:ssd_app/models/cart_product.dart';
import 'package:ssd_app/services/database_helper.dart';
import '../models/product.dart';
import '../services/cart_services.dart';
import 'connectivity_controller.dart';
import 'login_controller.dart';

class CartController extends GetxController {
  final isLoading = true.obs;
  final cartProducts = <CartProduct>[].obs;
  final CartService _cartService = CartService();
  final totalPrice = 0.0.obs;
  ConnectivityController connectivityController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  int get totalItemsInCart {
    return cartProducts.fold<int>(0, (total, cartProduct) {
      return total + cartProduct.quantity;
    });
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading(true);
      final dbHelper = DatabaseHelper();
      List<CartProduct> fetchedCartProducts;
      if (connectivityController.hasInternet.isTrue) {
        final LoginController loginController = Get.find();
        final String authToken = loginController.user.value!.apiToken;
        await syncWithLocal();
        fetchedCartProducts = await _cartService.fetchCartItems(authToken);
        await dbHelper.clearCartItems();
        await dbHelper.insertCartItems(fetchedCartProducts);
      } else {
        fetchedCartProducts = await dbHelper.getAllCartProducts();
        totalPrice.value = cartProducts.fold<double>(0.0, (total, cartProduct) {
          return total + (cartProduct.quantity * cartProduct.price);
        });
      }
      cartProducts.assignAll(fetchedCartProducts);
    } catch (error) {
      print('Error fetching cart items: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<void> syncWithLocal() async {
    try {
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value!.apiToken;
      final dbHelper = DatabaseHelper();
      List<CartProduct> newlyAddedProducts =
          await dbHelper.getNewlyAddedCartProducts();
      List<CartProduct> updatedProducts =
          await dbHelper.getUpdatedCartProducts();
      List<CartProduct> addedAndUpdatedProducts =
          await dbHelper.getAddedAndUpdatedCartProducts();
      List<CartProduct> deletedProducts =
          await dbHelper.getDeletedCartProducts();

      for (final cartProduct in newlyAddedProducts) {
        ProductController productController = Get.find();
        Product? product =
            await productController.findProduct(cartProduct.productId);
        await _cartService.insertIntoCart(authToken, product!);
      }

      for (final cartProduct in updatedProducts) {
        CartProduct newCartProduct = CartProduct(
          id: cartProduct.id,
          slabId: cartProduct.slabId,
          inventoryId: cartProduct.inventoryId,
          productId: cartProduct.productId,
          name: cartProduct.name,
          price: cartProduct.price,
          mrp: cartProduct.mrp,
          quantity: cartProduct.quantity - 1,
        );
        await _cartService.addToCart(authToken, newCartProduct);
      }

      for (final cartProduct in addedAndUpdatedProducts) {
        ProductController productController = Get.find();
        Product? product =
            await productController.findProduct(cartProduct.productId);
        await _cartService.insertIntoCart(authToken, product!);
        CartProduct newCartProduct = CartProduct(
          id: cartProduct.id,
          slabId: cartProduct.slabId,
          inventoryId: cartProduct.inventoryId,
          productId: cartProduct.productId,
          name: cartProduct.name,
          price: cartProduct.price,
          mrp: cartProduct.mrp,
          quantity: cartProduct.quantity - 1,
        );
        await _cartService.addToCart(authToken, newCartProduct);
      }

      for (final cartProduct in deletedProducts) {
        await _cartService.deleteFromCart(authToken, cartProduct);
      }
    } catch (error) {
      print('Error syncing cart products: $error');
    }
  }

  Future<void> insertIntoCart(Product product) async {
    try {
      isLoading(true);
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value!.apiToken;

      final dbHelper = DatabaseHelper();

      if (connectivityController.hasInternet.isTrue) {
        await _cartService.insertIntoCart(authToken, product);
        List<CartProduct> fetchedCartProducts =
            await _cartService.fetchCartItems(authToken);
        await dbHelper.clearCartItems();
        await dbHelper.insertCartItems(fetchedCartProducts);
      } else {
        List<CartProduct> allCartProducts = await dbHelper.getProducts();
        final existingCartProduct = allCartProducts.firstWhere(
          (cartProduct) => cartProduct.productId == product.id,
          orElse: () => CartProduct(
              id: 0,
              slabId: 0,
              inventoryId: 0,
              productId: 0,
              name: "",
              price: 0.0,
              mrp: 0.0,
              quantity: 0),
        );

        if (existingCartProduct.id != 0) {
          CartProduct cartProduct = toCartProduct(product);
          await dbHelper.addCartProduct(cartProduct);
        } else {
          await dbHelper.insertCartProduct(product);
        }
      }
      await fetchCartItems();
    } catch (error) {
      print('Error adding product to cart: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart(Product product) async {
    try {
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value!.apiToken;
      CartProduct cartProduct = toCartProduct(product);
      if (connectivityController.hasInternet.isTrue) {
        await _cartService.addToCart(authToken, cartProduct);
        final dbHelper = DatabaseHelper();
        List<CartProduct> fetchedCartProducts =
            await _cartService.fetchCartItems(authToken);
        await dbHelper.clearCartItems();
        await dbHelper.insertCartItems(fetchedCartProducts);
      } else {
        final dbhelper = DatabaseHelper();
        await dbhelper.addCartProduct(cartProduct);
      }

      await fetchCartItems();
    } catch (error) {
      print('Error adding product to cart: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      isLoading(true);
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value!.apiToken;
      CartProduct cartProduct = toCartProduct(product);
      if (connectivityController.hasInternet.isTrue) {
        await _cartService.removeFromCart(authToken, cartProduct);
        final dbHelper = DatabaseHelper();
        List<CartProduct> fetchedCartProducts =
            await _cartService.fetchCartItems(authToken);
        await dbHelper.clearCartItems();
        await dbHelper.insertCartItems(fetchedCartProducts);
      } else {
        final dbhelper = DatabaseHelper();
        await dbhelper.removeCartProduct(cartProduct);
      }
      await fetchCartItems();
    } catch (error) {
      print('Error adding product to cart: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteFromCart(Product product) async {
    try {
      isLoading(true);
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value!.apiToken;
      CartProduct cartProduct = toCartProduct(product);
      if (connectivityController.hasInternet.isTrue) {
        await _cartService.deleteFromCart(authToken, cartProduct);
        final dbHelper = DatabaseHelper();
        List<CartProduct> fetchedCartProducts =
            await _cartService.fetchCartItems(authToken);
        await dbHelper.clearCartItems();
        await dbHelper.insertCartItems(fetchedCartProducts);
      } else {
        final dbhelper = DatabaseHelper();
        await dbhelper.deleteCartProduct(cartProduct);
      }
      await fetchCartItems();
    } catch (error) {
      print('Error adding product to cart: $error');
    } finally {
      isLoading(false);
    }
  }

  int getProductInCart(Product product) {
    final cartProduct = cartProducts.firstWhere(
      (cartProduct) => cartProduct.productId == product.id,
      orElse: () => CartProduct(
        id: 0,
        slabId: 0,
        inventoryId: 0,
        productId: 0,
        name: "",
        price: 0.0,
        quantity: 0,
        mrp: 0.0,
      ),
    );
    return cartProduct.quantity;
  }

  CartProduct toCartProduct(Product product) {
    final cartProduct = cartProducts.firstWhere(
      (cartProduct) => cartProduct.productId == product.id,
      orElse: () => CartProduct(
        id: 0,
        slabId: 0,
        inventoryId: 0,
        productId: 0,
        name: "",
        price: 0.0,
        quantity: 0,
        mrp: 0.0,
      ),
    );
    return cartProduct;
  }
}
