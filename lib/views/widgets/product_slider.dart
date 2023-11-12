// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../consts/assets.dart';

List SLIDES = [BASKET, PROMO, PRODUCT_IMG];

Widget ProductSlider(int index) {
  return Container(
    width: 75.w,
    color: Get.theme.scaffoldBackgroundColor,
    height: 20.h,
    child: Image.asset(SLIDES[index]),
  );
}
