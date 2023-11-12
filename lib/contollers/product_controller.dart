// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:ssd_app/models/product.dart';
import '../services/database_helper.dart';
import '../services/product_services.dart';
import 'connectivity_controller.dart';
import 'login_controller.dart';

class ProductController extends GetxController {
  final isLoading = true.obs;
  final products = <Product>[].obs;
  final categoryProducts = <Product>[].obs;
  final allProducts = <Product>[].obs;
  final ProductService _productService = ProductService();
  final RxInt currentPage = 1.obs;
  final RxInt totalProducts = 0.obs;
  final ConnectivityController connectivityController = Get.find();
  @override
  void onInit() async {
    super.onInit();
    fetchFeaturedProducts();
  }

  Future<void> fetchFeaturedProducts() async {
    try {
      isLoading(true);

      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value?.apiToken ?? "";
      final dbHelper = DatabaseHelper();
      List<Product> fetchedProducts;
      if (connectivityController.hasInternet.isTrue) {
        fetchedProducts =
            await _productService.fetchFeaturedProducts(authToken);
        await dbHelper.clearFeaturedProducts();
        await dbHelper.insertFeaturedProducts(fetchedProducts);
      } else {
        fetchedProducts = await dbHelper.getAllFeaturedProducts();
        
      }
      products.assignAll(fetchedProducts);
    } catch (error) {
      print('Error: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategoryProducts(int category) async {
    try {
      isLoading(true);
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value?.apiToken ?? "";
      final fetchedProducts =
          await _productService.fetchProductsByCategory(authToken, category);
      categoryProducts.assignAll(fetchedProducts);
    } catch (error) {
      print('Error in category products : $error');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      isLoading(true);
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value?.apiToken ?? "";
      final fetchedProducts =
          await _productService.fetchAllProducts(authToken, currentPage.value);
      allProducts.addAll(fetchedProducts);
      currentPage.value++;
      totalProducts.value = allProducts.length;
    } catch (error) {
      print('Error fetching all products: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadNextPage() async {
    try {
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value?.apiToken ?? "";
      final nextPageProducts = await _productService.fetchAllProducts(
          authToken, currentPage.value + 1);

      if (nextPageProducts.isNotEmpty) {
        allProducts.addAll(nextPageProducts);
        currentPage.value++;
      }
    } catch (error) {
      print('Error loading next page: $error');
    }
  }

  Future<Product?> findProduct(int productId) async {
    try {
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value?.apiToken ?? "";
      Product? fetchedProduct;
      if (connectivityController.hasInternet.isTrue) {
        fetchedProduct =
            await _productService.findProduct(authToken, productId);
      } else {
        final product = products.firstWhere(
          (product) => product.id == productId,
          orElse: () => Product(
            id: 0,
            name: '',
            description: '',
            category: 0,
            sellingPrice: 0.0,
            mrp: 0.0,
            inventoryId: 0,
            productSlabs: [],
          ),
        );
        fetchedProduct = product;
      }
      return fetchedProduct;
    } catch (error) {
      print('Error fetching product : $error');
    }
    return null;
  }

  String calculateSlabId(int quantity, Product product) {
    for (var slab in product.productSlabs) {
      if (quantity >= slab.slabMinValue &&
          (quantity <= slab.slabMaxValue || slab.slabMaxValue == 0)) {
        return slab.id.toString();
      }
    }
    return "";
  }
}
