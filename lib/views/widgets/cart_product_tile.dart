// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, unrelated_type_equality_checks, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/consts/assets.dart';
import 'package:ssd_app/contollers/cart_controller.dart';
import 'package:ssd_app/contollers/product_controller.dart';
import 'package:ssd_app/models/cart_product.dart';
import 'package:ssd_app/models/product.dart';

Widget CartProductTile(CartProduct cartProduct) {
  ProductController productController = Get.find();
  CartController cartController = Get.find();
  final isLoading = false.obs;
  final removeLoading = false.obs;
  return Obx(() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(1.w),
        margin: EdgeInsets.symmetric(vertical: 0.1.h),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          border: Border.all(
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 9.h,
              child: Image.asset(
                PRODUCT_IMG,
                fit: BoxFit.cover,
              ),
            ),
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70.w,
                      child: Text(
                        cartProduct.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      // width: 60.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MRP : ₹ ${cartProduct.mrp}",
                            style: TextStyle(
                              fontSize: 10.sp,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.orange,
                              decorationThickness: 0.2.h,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Our Price : ₹ ${cartProduct.price.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                      width: 75.w,
                      height: 0.1.h,
                      color: Colors.blueGrey,
                    ),
                    Container(
                      child: cartProduct != 0
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    isLoading(true);
                                    Product? product = await productController
                                        .findProduct(cartProduct.productId);
                                    if (cartProduct.quantity == 1) {
                                      await cartController
                                          .deleteFromCart(product!);
                                    } else {
                                      await cartController
                                          .removeFromCart(product!);
                                    }
                                    isLoading(false);
                                  },
                                  child: Container(
                                    width: 8.w,
                                    child: Image.asset(MINUS_ICON),
                                  ),
                                ),
                                Container(
                                  child: isLoading.isTrue
                                      ? Container(
                                          height: 8.w,
                                          width: 8.5.w,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            strokeWidth: 2.sp,
                                          )),
                                        )
                                      : Text(
                                          " ${cartProduct.quantity.toString().padLeft(2, '0')} ",
                                          style: TextStyle(fontSize: 15.sp),
                                        ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    isLoading(true);
                                    Product? product = await productController
                                        .findProduct(cartProduct.productId);
                                    cartController.addToCart(product!);
                                    isLoading(false);
                                  },
                                  child: Container(
                                    width: 8.w,
                                    child: Image.asset(PLUS_ICON),
                                  ),
                                ),
                                Text(
                                  "  x  ₹ ${cartProduct.price.toString()} = ",
                                  style: TextStyle(
                                    color: Get.theme.hintColor,
                                  ),
                                ),
                                Text(
                                  "${((cartProduct.price * cartProduct.quantity).toStringAsFixed(2))}",
                                  style: TextStyle(
                                    color: Get.theme.hintColor,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              child: isLoading.isTrue
                                  ? Container(
                                      height: 8.5.w,
                                      width: 8.5.w,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.sp,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        isLoading(true);
                                        Product? product =
                                            await productController.findProduct(
                                                cartProduct.productId);
                                        cartController.insertIntoCart(product!);
                                        isLoading(false);
                                      },
                                      child: Container(
                                        width: 8.w,
                                        child: Image.asset(PLUS_ICON),
                                      ),
                                    ),
                            ),
                    ),
                  ],
                ),
                Positioned(
                  top: -1.h,
                  right: -3.w,
                  child: Container(
                    child: removeLoading.isTrue
                        ? Container(
                            margin: EdgeInsets.only(top: 3.h, right: 2.w),
                            height: 3.h,
                            width: 3.h,
                            child: CircularProgressIndicator(),
                          )
                        : IconButton(
                            onPressed: () async {
                              removeLoading(true);
                              Product? product = await productController
                                  .findProduct(cartProduct.productId);
                              cartController.deleteFromCart(product!);
                              removeLoading(false);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 18.sp,
                              color: Get.theme.hintColor,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}
