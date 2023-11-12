// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/contollers/cart_controller.dart';
import 'package:ssd_app/contollers/catergory_controller.dart';
import 'package:ssd_app/contollers/connectivity_controller.dart';
import 'package:ssd_app/contollers/login_controller.dart';
import 'package:ssd_app/contollers/product_controller.dart';
import 'package:ssd_app/views/pages/all_products.dart';
import 'package:ssd_app/views/pages/categories_page.dart';
import 'package:ssd_app/views/widgets/cart_icon.dart';
import 'package:ssd_app/views/widgets/category_tile.dart';
import 'package:ssd_app/views/widgets/product_tile.dart';
import 'package:ssd_app/views/widgets/home_end_drawer.dart';

import '../../models/product.dart';
import '../widgets/top_slider_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginController loginController = Get.find();
  final RxInt _currentIndex = 0.obs;
  CategoryController categoryController = Get.put(CategoryController());
  CartController cartController = Get.put(CartController());
  ProductController productController = Get.put(ProductController());
  ConnectivityController connectivityController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CartIcon()],
            ),
          ),
          endDrawer: HomeEndDrawer(),
          body: Center(
            child: loginController.isLoading.isTrue ||
                    productController.isLoading.isTrue
                ? CircularProgressIndicator()
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 36.h,
                            child: Column(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 2),
                                    onPageChanged: (index, reason) {
                                      _currentIndex.value = index;
                                    },
                                  ),
                                  items: List.generate(5, (index) {
                                    return TopSliderWidget(index);
                                  }),
                                ),
                                SizedBox(height: 1.h),
                                DotsIndicator(
                                  dotsCount: 5,
                                  position: _currentIndex.value,
                                  decorator: DotsDecorator(
                                    activeColor: Colors.deepPurple,
                                    color: Colors.grey,
                                    size: Size(5, 3),
                                    activeSize: Size(22, 3),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.sp)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Top Categories",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.to(CategoriesPage());
                                      },
                                      child: Text("View All"),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.5.h),
                                  child: categoryController.isLoading.isTrue
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : categoryController.categories.isEmpty
                                          ? Center(
                                              child:
                                                  Text("No Categories Found"),
                                            )
                                          : Wrap(
                                              children: List.generate(
                                                8,
                                                (index) => CatergoryTile(
                                                    categoryController
                                                        .categories[index]),
                                              ),
                                            ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Featured Products",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    productController.isLoading.isTrue
                                        ? CircularProgressIndicator()
                                        : TextButton(
                                            onPressed: () {
                                              Get.to(AllProductsPage());
                                            },
                                            child: Text("View All"),
                                          ),
                                  ],
                                ),
                                Container(
                                  child: productController.isLoading.isTrue
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : productController.products.isEmpty
                                          ? Center(
                                              child: Text("No product to show"),
                                            )
                                          : Column(
                                              children: List.generate(
                                                20,
                                                (index) {
                                                  Product product =
                                                      productController
                                                          .products[index];
                                                  return ProductTile(product);
                                                },
                                              ),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
