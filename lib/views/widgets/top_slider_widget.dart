// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../consts/assets.dart';

List SLIDES = [BACKGROUND_CORNER, BASKET, FULL_LOGO, PROMO, PRODUCT_IMG, LOGO];

Widget TopSliderWidget(int index) {
  return Container(
    height: 20.h,
    child: Image.asset(SLIDES[index],fit: BoxFit.fitHeight,),
  );
}
