// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/views/pages/category_product.dart';

import '../../models/category.dart';

Widget CatergoryTile(Category category) {
  final hue = (category.id * 5) % 360.0;
  final color = HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();
  return InkWell(
    onTap: () {
      Get.to(CatergoryProducsPage(category: category));
    },
    child: Container(
      margin: EdgeInsets.all(1.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.4),
      ),
      child: Text(category.name),
    ),
  );
}
