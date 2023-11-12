// ignore_for_file: sized_box_for_whitespace, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/consts/assets.dart';
import 'package:ssd_app/contollers/cart_controller.dart';
import 'package:ssd_app/models/product.dart';
import 'package:ssd_app/utils/getCatergoryName.dart';
import 'package:ssd_app/views/widgets/product_slider.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({required this.product, super.key});
  Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final RxInt _currentIndex = 0.obs;
  final CartController cartController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cartController.fetchCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.product.name),
          ),
          backgroundColor: Get.theme.canvasColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 36.h,
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            _currentIndex.value = index;
                          },
                        ),
                        items: List.generate(3, (index) {
                          return ProductSlider(index);
                        }),
                      ),
                      SizedBox(height: 1.h),
                      DotsIndicator(
                        dotsCount: 3,
                        position: _currentIndex.value,
                        decorator: DotsDecorator(
                          activeColor: Colors.deepPurple,
                          color: Colors.grey,
                          size: Size(5, 3),
                          activeSize: Size(22, 3),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.sp)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: double.infinity),
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        getCategoryNameById(widget.product.category),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: Colors.green.shade800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: double.infinity,
                        color: Get.theme.cardColor,
                        padding: EdgeInsets.all(2.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MRP : ₹ ${widget.product.mrp}",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.orange,
                                        decorationThickness: 0.2.h,
                                      ),
                                    ),
                                    Text(
                                      "Our Price : ₹ ${widget.product.sellingPrice.toString()}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: cartController.isLoading.isTrue
                                      ? Container(
                                          width: 50.w,
                                          height: 6.h,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()))
                                      : cartController.getProductInCart(
                                                  widget.product) !=
                                              0
                                          ? Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    if (cartController
                                                            .getProductInCart(
                                                                widget
                                                                    .product) ==
                                                        1) {
                                                      cartController
                                                          .deleteFromCart(
                                                              widget.product);
                                                    } else {
                                                      cartController
                                                          .removeFromCart(
                                                              widget.product);
                                                    }
                                                  },
                                                  child: Container(
                                                    child:
                                                        Image.asset(MINUS_ICON),
                                                  ),
                                                ),
                                                Text(
                                                  " ${cartController.getProductInCart(widget.product).toString().padLeft(2, '0')} ",
                                                  style: TextStyle(
                                                      fontSize: 15.sp),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    cartController.addToCart(
                                                        widget.product);
                                                  },
                                                  child: Container(
                                                    child:
                                                        Image.asset(PLUS_ICON),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                cartController.insertIntoCart(
                                                    widget.product);
                                              },
                                              child: Container(
                                                child: Image.asset(PLUS_ICON),
                                              ),
                                            ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Divider(),
                            SizedBox(height: 2.h),
                            Text(
                              "Product Description",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                                child: widget.product.description.isEmpty
                                    ? Text("Not Available")
                                    : Text(widget.product.description)),
                            SizedBox(height: 2.h),
                            Divider(),
                            SizedBox(height: 2.h),
                            Text(
                              "Discount On Quantity",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              child: widget.product.productSlabs.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: List.generate(
                                              widget.product.productSlabs
                                                      .length -
                                                  1, (index) {
                                            ProductSlab slab = widget
                                                .product.productSlabs[index];
                                            return Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "Buy ${slab.slabMinValue} units & save ₹ ${(widget.product.sellingPrice - slab.sellingPrice).toStringAsFixed(2)} per unit.")
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                        Text(
                                          "Buy ${widget.product.productSlabs[widget.product.productSlabs.length - 2].slabMaxValue + 1} units & save ₹ ${(widget.product.sellingPrice - widget.product.productSlabs[widget.product.productSlabs.length - 1].sellingPrice).toStringAsFixed(2)} per unit.",
                                        )
                                      ],
                                    )
                                  : Container(
                                      child: Text("No discount available"),
                                    ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
