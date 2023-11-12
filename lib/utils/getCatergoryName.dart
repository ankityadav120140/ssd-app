// ignore_for_file: file_names

import 'package:get/get.dart';
import '../contollers/catergory_controller.dart';
import '../models/category.dart';

final CategoryController categoryController = Get.find();

String getCategoryNameById(int id) {
  final category = categoryController.categories.firstWhere(
    (category) => category.id == id,
    orElse: () => Category(id: 0, name: 'Unknown'),
  );
  return category.name;
}
