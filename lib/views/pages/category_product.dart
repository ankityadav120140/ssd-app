// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../contollers/product_controller.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../widgets/product_tile.dart';

class CatergoryProducsPage extends StatefulWidget {
  CatergoryProducsPage({required this.category, super.key});

  final Category category;

  @override
  State<CatergoryProducsPage> createState() => _CatergoryProducsPageState();
}

class _CatergoryProducsPageState extends State<CatergoryProducsPage> {
  ProductController productController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await productController.fetchCategoryProducts(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category : ${widget.category.name}"),
      ),
      body: Obx(() {
        if (productController.isLoading.isTrue) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Column(
              children: [
                Expanded(
                  child: productController.categoryProducts.isEmpty
                      ? Center(
                          child: Text("No product found of this category"),
                        )
                      : ListView.builder(
                          itemCount: productController.categoryProducts.length,
                          itemBuilder: (context, index) {
                            Product product =
                                productController.categoryProducts[index];
                            return ProductTile(product);
                          },
                        ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
