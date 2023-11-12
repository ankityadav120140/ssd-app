// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssd_app/contollers/catergory_controller.dart';
import 'package:ssd_app/contollers/product_controller.dart';
import 'package:ssd_app/views/widgets/category_tile.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});
  CategoryController categoryController = Get.find();
  ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catergories"),
      ),
      body: Obx(() {
        if (categoryController.isLoading.isTrue ||
            productController.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Wrap(
            children: List.generate(categoryController.categories.length,
                (index) => CatergoryTile(categoryController.categories[index])),
          ),
        );
      }),
    );
  }
}
