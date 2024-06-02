// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controller/popular-item-controller.dart';

class PopularWidget extends StatefulWidget {
  const PopularWidget({Key? key}) : super(key: key);

  @override
  State<PopularWidget> createState() => _PopularWidgetState();
}

class _PopularWidgetState extends State<PopularWidget> {
  final PopularController popularController = Get.put(PopularController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (popularController.bannerUrls.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          enlargeCenterPage: true,
        ),
        items: popularController.bannerUrls.map((imageURL) {
          return CachedNetworkImage(
            imageUrl: imageURL,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          );
        }).toList(),
      );
    });
  }
}
