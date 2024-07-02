import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/screens/user/checkout-screen.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/utils/AppConstant.dart';
import 'package:shopping_app/utils/global-variables.dart';

class SelectService extends StatelessWidget {

  GloablVariableDeclaration globalVariableDeclaration = GloablVariableDeclaration();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            "Service",
            style: TextStyle(color: Colors.white),
          ),
        
          backgroundColor: AppConstant.colorBlue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Select Service:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildServiceButton(
                context,
                "Self-pick-up",
                () {
                  globalVariableDeclaration.setSelectService(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(selectService: true),
                    ),
                  );
                },
              ),
              _buildServiceButton(
                context,
                "Order",
                () {
                  globalVariableDeclaration.setSelectService(false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(selectService: false),
                    ),
                  );
                },
              ),
              _buildServiceButton(
                context,
                "Order-on-preferred time",
                () {
                  globalVariableDeclaration.setSelectService(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(selectService: true),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildServiceButton(
                context,
                "Cancel",
                () {
                  globalVariableDeclaration.setSelectService(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.blue,
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
                break;
              case 1:
                // Handle cart navigation
                break;
              case 2:
                // Handle profile navigation
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildServiceButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }
}
