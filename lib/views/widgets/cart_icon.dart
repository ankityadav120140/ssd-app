// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/consts/assets.dart';
import 'package:ssd_app/views/pages/cart_page.dart';

import '../../contollers/cart_controller.dart';

Widget CartIcon() {
  final CartController cartController = Get.find();
  return Obx(() {
    return InkWell(
      onTap: () {
        Get.to(CartPage());
      },
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 16.sp,
          ),
          Container(
            width: 10.w,
            child: Image.asset(
              CART_ICON,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              radius: 3.w,
              backgroundColor: Colors.amber,
              child: Text(
                cartController.totalItemsInCart.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
            ),
          )
        ],
      ),
    );
  });
}
