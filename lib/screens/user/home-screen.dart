//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore: unused_import
// ignore_for_file: file_names, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/screens/auth-ui/welcome-screen.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/utils/AppConstant.dart';
import 'package:shopping_app/widgets/banner-widget.dart';
import 'package:shopping_app/widgets/custom-drawer-widget.dart';
import 'package:shopping_app/widgets/heading-widget.dart';

import '../../widgets/Categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
            // leading: const Icon(
            //   Icons.menu,
            //   color: Colors.white,
            // ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  // Handle logout
                  await _auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              ),
            ],
            backgroundColor: AppConstant.colorBlue),
        drawer: DrawerWidget(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppConstant.colorBlue,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstant.colorWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: const Icon(Icons.mic),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    // HeadingWidget(
                    //   headingTitle: "Just for you",
                    //   subTitle: "Recommended",
                    //   buttonText: "View All",
                    //   onTap: () {
                    //     // Handle the tap event
                    //   },
                    // ),
                    // BannerWidget(),
                    HeadingWidget(
                      headingTitle: "Categories",
                      subTitle: "Explore the categories",
                      buttonText: "View All",
                      onTap: () {
                        // Handle the tap event
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllCategoriesScreen(),
                          ),
                        );
                      },
                    ),
                    Categories(),

                    HeadingWidget(
                      headingTitle: "Categories",
                      subTitle: "Explore the categories",
                      buttonText: "View All",
                      onTap: () {
                        // Handle the tap event
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllCategoriesScreen(),
                          ),
                        );
                      },
                    ),
                    BannerWidget(),

                    SizedBox(
                      height: 20.h,
                    ),
                    HeadingWidget(
                        headingTitle: "Popular Items",
                        subTitle: "Choose what you like",
                        buttonText: "View All",
                        onTap: () {
                          // Handle the tap event
                        }),
                    Categories(),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // Set the initial index of the selected item
          selectedItemColor: AppConstant.colorBlue, // Set the color of the selected item
          unselectedItemColor:
              Colors.grey, // Set the color of the unselected items
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
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
            // Handle the tap event for each item
            switch (index) {
              case 0:
                // Handle the Home item tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 1:
                // Handle the Wishlist item tap
                break;
              case 2:
                // Handle the Categories item tap
                break;
              case 3:
                // Handle the Cart item tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                        // cartItems: [],
                        ),
                  ),
                );
                break;
              case 4:
                // Handle the Profile item tap
                break;
            }
          },
        ),
      ),
    );
  }
}
