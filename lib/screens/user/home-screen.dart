import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shopping_app/controller/popular-item-controller.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/screens/user/all-product-screen.dart';
import 'package:shopping_app/screens/user/product-detailscreen.dart';

import '../../My Cart/my_cart_view.dart';
import '../../controller/cart-controller.dart';
import '../../models/product-model.dart';
import '../../utils/AppConstant.dart';
import '../../widgets/Categories.dart';
import '../../widgets/custom-drawer-widget.dart';
import '../../widgets/heading-widget.dart';
import '../../widgets/voucher-widget.dart';
import '../auth-ui/welcome-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartController cartController = Get.put(CartController());
  final PopularController popularController = Get.put(PopularController());

  TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = popularController.products;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = popularController.products.where((product) {
        return product.productName.toLowerCase().contains(query);
      }).toList();
    });
  }

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
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await _auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
          backgroundColor: AppConstant.colorBlue,
        ),
        drawer: DrawerWidget(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppConstant.colorBlue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppConstant.colorWhite,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: TextField(
                        controller: _searchController,
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          HeadingWidget(
                            headingTitle: "Categories",
                            subTitle: "",
                            buttonText: "See All",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllCategoriesScreen(),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Categories(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          HeadingWidget(
                            headingTitle: "Popular",
                            subTitle: "",
                            buttonText: "See All",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllPopularItemsScreen()));
                            },
                          ),
                          Obx(() {
                            return CarouselSlider.builder(
                              itemCount: (_filteredProducts.length / 5).ceil(),
                              itemBuilder: (context, index, _) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3,
                                      childAspectRatio: .6,
                                    ),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _filteredProducts.length,
                                    itemBuilder: (context, innerIndex) {
                                      int realIndex = index * 5 + innerIndex;
                                      if (realIndex >=
                                          _filteredProducts.length) {
                                        return SizedBox.shrink();
                                      }
                                      ProductModel product =
                                          _filteredProducts[realIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailScreen(
                                                productModel: product,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CachedNetworkImage(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  imageUrl:
                                                      product.productImages[0],
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.productName,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Sale Price: ${product.salePrice}',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Full Price: ${product.fullPrice}',
                                                      style: TextStyle(
                                                          fontSize: 14),
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
                              },
                              options: CarouselOptions(
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          HeadingWidget(
                            headingTitle: "Vouchers",
                            subTitle: "Make your shopping more fun",
                            buttonText: "View All",
                            onTap: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: VoucherWidget(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
