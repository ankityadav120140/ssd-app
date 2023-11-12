// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/consts/assets.dart';

Widget AuthTopWidget() {
  return Container(
    height: 50.h,
    child: Stack(
      children: [
        Container(
          height: 40.h,
          padding: EdgeInsets.only(left: 10.w),
          child: Image.asset(
            BACKGROUND_CORNER,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 1.h,
            ),
            Container(
              height: 10.h,
              child: Image.asset(FULL_LOGO),
            ),
            Container(
              height: 39.h,
              child: Image.asset(BASKET),
            ),
          ],
        )
      ],
    ),
  );
}
