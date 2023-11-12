// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/consts/assets.dart';
import 'package:ssd_app/contollers/cart_controller.dart';
import 'package:ssd_app/models/product.dart';
import 'package:ssd_app/utils/getCatergoryName.dart';
import 'package:ssd_app/views/pages/product_details.dart';

Widget ProductTile(Product product) {
  final CartController cartController = Get.find();
  final RxBool isLoading = false.obs;

  return Obx(() {
    return InkWell(
      onTap: () {
        Get.to(ProductDetailsPage(
          product: product,
        ));
      },
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
              width: 20.w,
              child: Image.asset(PRODUCT_IMG),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70.w,
                  child: Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(getCategoryNameById(product.category)),
                Container(
                  width: 70.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MRP : ₹ ${product.mrp}",
                            style: TextStyle(
                              fontSize: 10.sp,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.orange,
                              decorationThickness: 0.2.h,
                            ),
                          ),
                          Text(
                            "Our Price : ₹ ${product.sellingPrice.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: cartController.getProductInCart(product) != 0
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      isLoading.value = true;
                                      if (cartController
                                              .getProductInCart(product) ==
                                          1) {
                                        await cartController
                                            .deleteFromCart(product);
                                      } else {
                                        await cartController
                                            .removeFromCart(product);
                                      }
                                      isLoading.value = false;
                                    },
                                    child: Container(
                                      width: 8.w,
                                      child: Image.asset(MINUS_ICON),
                                    ),
                                  ),
                                  Container(
                                    child: isLoading.isTrue
                                        ? Container(
                                            height: 8.5.w,
                                            width: 8.5.w,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              strokeWidth: 2.sp,
                                            )),
                                          )
                                        : Text(
                                            " ${cartController.getProductInCart(product).toString().padLeft(2, '0')} ",
                                            style: TextStyle(fontSize: 15.sp),
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      isLoading.value = true;
                                      await cartController.addToCart(product);
                                      isLoading.value = false;
                                    },
                                    child: Container(
                                      width: 8.w,
                                      child: Image.asset(PLUS_ICON),
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
                                          isLoading.value = true;
                                          await cartController
                                              .insertIntoCart(product);
                                          isLoading.value = false;
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}
