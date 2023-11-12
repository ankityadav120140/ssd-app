// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/contollers/cart_controller.dart';
import 'package:ssd_app/views/widgets/cart_product_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartController cartController = Get.find();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Obx(() {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Column(
            children: [
              Container(
                  height: 65.h,
                  child: cartController.cartProducts.isNotEmpty
                      ? ListView.builder(
                          itemCount: cartController.cartProducts.length,
                          itemBuilder: (context, index) {
                            return CartProductTile(
                                cartController.cartProducts[index]);
                          },
                        )
                      : Center(
                          child: Text("Cart is empty !"),
                        )),
              Container(
                // height: 30.h,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Column(
                  children: [
                    Divider(),
                    Column(
                      children: cartController.cartProducts.isEmpty
                          ? []
                          : [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Billing Amount : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${(cartController.totalPrice).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey,
                                        fontSize: 12.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5.w),
                                padding: EdgeInsets.all(1.5.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.deepPurple,
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Proceed to Check Out",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 13.sp),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
