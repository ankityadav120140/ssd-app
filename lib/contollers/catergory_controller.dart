// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:ssd_app/contollers/connectivity_controller.dart';
import 'package:ssd_app/contollers/login_controller.dart';
import 'package:ssd_app/models/category.dart';

import '../services/catergory_services.dart';
import '../services/database_helper.dart';

class CategoryController extends GetxController {
  final isLoading = true.obs;
  final categories = <Category>[].obs;
  final CategoryService _categoryService = CategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final ConnectivityController connectivityController = Get.find();
      final LoginController loginController = Get.find();
      final String authToken = loginController.user.value!.apiToken;
      final dbHelper = DatabaseHelper();
      List<Category> fetchedCategories;
      if (connectivityController.hasInternet.isTrue) {
        fetchedCategories = await _categoryService.fetchCategories(authToken);
        await dbHelper.clearCategories();
        await dbHelper.insertCategories(fetchedCategories);
      } else {
        fetchedCategories = await dbHelper.getAllCategories();
      }
      categories.assignAll(fetchedCategories);
    } catch (error) {
      print('Error: $error');
    } finally {
      isLoading(false);
    }
  }
}
