import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/screens/user/single-category-product-screen.dart';

import '../models/Category-model.dart';

class Categories extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("categories").get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No data found"),
            );
          } else {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * .8,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          var data = document.data() as Map<String, dynamic>;
                          CategoriesModel category = CategoriesModel(
                            categoryId: data['categoryId'],
                            categoryImg: data['categoryImg'],
                            categoryName: data['categoryName'],
                            createdAt: data['createdAt'],
                            updatedAt: data['updatedAt'],
                          );
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleProductView(
                                      categoryId: category.categoryId,
                                      categoryName: category.categoryName,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image(
                                    image: CachedNetworkImageProvider(category.categoryImg),
                                    height: 100.h,
                                  ),
                                  Text(category.categoryName),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}
