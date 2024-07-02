// ignore_for_file: prefer_const_constructors, use_super_parameters, unused_local_variable, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/controller/cart-model-controller.dart';
import 'package:shopping_app/screens/user/checkout-screen.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/product-detailscreen.dart';
import 'package:shopping_app/utils/AppConstant.dart';
import '../../My Cart/my_cart_view.dart';
import '../../models/product-model.dart';

class SingleProductView extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final CartController cartController = Get.put(CartController());
  final CheckoutScreen checkoutScreen = CheckoutScreen();
  User? user = FirebaseAuth.instance.currentUser;
  SingleProductView(
      {Key? key, required this.categoryId, required this.categoryName , })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BindingsBuilder(() {
      Get.put(CartController());
    });
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstant.colorBlue,
        title: Center(child: Text(categoryName, style: TextStyle(color: Colors.white))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: categoryId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Products not found for this category!"));
          }

          return // Your code with adjustments
              GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: .4, // Adjusted value
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              ProductModel product = ProductModel.fromMap(
                snapshot.data!.docs[index].data() as Map<String, dynamic>,
              );
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(productModel: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(productModel: product),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.5,
                            imageUrl: product.productImages[0],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.fitWidth,
                          ),
                        ), // Placeholder or empty container if URL is null
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Sale Price: ${product.salePrice} RM',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Full Price: ${product.fullPrice} RM',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .blue,
                                    // padding: EdgeInsets.symmetric(vertical: 12), // Set the background color here
                              ),
                              onPressed: () {
                                if (cartController.cartItems.any((element) =>
                                    element.productId == product.productId)) {
                                  cartController
                                      .removeFromCart(product.productId);
                                  Get.snackbar('Product already in cart',
                                      'Please go to cart to update quantity');
                                  return;
                                } else {
                                  cartController.addToCart(
                                    CartItem(
                                      productId: product.productId,
                                      productName: product.productName,
                                      productImage: product.productImages[0],
                                      price: product.salePrice,
                                    ),
                                  );
                                  // Get.snackbar('Product added to cart', 'You can update quantity in cart');
                                  Fluttertoast.showToast(
                                    msg: "Product added to cart",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppConstant.colorBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                      // cartItems: [],
                      ),
                ),
              );
              break;
            case 2:
              // Handle the Profile item tap
              break;
          }
        },
      ),
    );
  }
}
