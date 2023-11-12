// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/contollers/product_controller.dart';
import 'package:ssd_app/models/product.dart';

import '../widgets/product_tile.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  ProductController productController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await productController.fetchAllProducts();
      _scrollController.addListener(_onScroll);
      productController.fetchAllProducts();
    });
  }

  @override
  void dispose() {
    productController.allProducts.value = [];
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      productController.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
      ),
      body: Obx(() {
        {
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
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: productController.allProducts.length + 1,
                      itemBuilder: (context, index) {
                        if (index < productController.allProducts.length) {
                          Product product =
                              productController.allProducts[index];
                          return ProductTile(product);
                        } else {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            height: 7.h,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }),
    );
  }
}
