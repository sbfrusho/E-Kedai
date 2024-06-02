import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import 'package:shopping_app/const/app-colors.dart';
import 'package:shopping_app/screens/user/single-category-product-screen.dart';
import '../../models/Category-model.dart';
import '../../My Cart/my_cart_view.dart';
import '../../utils/AppConstant.dart';
import 'home-screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor().backgroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: AppConstant.colorBlue,
          title: Text(
            "All Categories",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: AppConstant.colorBlue,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection("categories").get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        CategoriesModel categoriesModel = CategoriesModel(
                          categoryId: snapshot.data!.docs[index]['categoryId'],
                          categoryImg: snapshot.data!.docs[index]['categoryImg'],
                          categoryName: snapshot.data!.docs[index]['categoryName'],
                          createdAt: snapshot.data!.docs[index]['createdAt'],
                          updatedAt: snapshot.data!.docs[index]['updatedAt'],
                        );
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleProductView(
                                  categoryId: categoriesModel.categoryId,
                                  categoryName: categoriesModel.categoryName,
                                  
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                // color: AppConstant.colorViolet,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: categoriesModel.categoryImg,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width:
                                          MediaQuery.of(context).size.width * 0.4,
                                      height:
                                          MediaQuery.of(context).size.height * 0.12,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    categoriesModel.categoryName,
                                    style: TextStyle(fontSize: 16 ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No data found"),
                    );
                  }
                  return Container();
                },
              ),
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
                    builder: (context) =>const HomeScreen(),
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
      ),
    );
  }
}
