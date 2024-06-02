import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controller/popular-item-controller.dart';
import 'package:shopping_app/models/product-model.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/product-detailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/utils/AppConstant.dart';

import '../../My Cart/my_cart_view.dart';

class AllPopularItemsScreen extends StatelessWidget {
  final PopularController popularController = Get.put(PopularController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Popular Items' , style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.colorBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              // HeadingWidget can be included here if needed
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: .6,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: popularController.products.length,
                    itemBuilder: (context, index) {
                      ProductModel product = popularController.products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                productModel: product,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
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
                                      'Sale Price: ${product.salePrice}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Full Price: ${product.fullPrice}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
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
