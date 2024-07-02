// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, avoid_print, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/controller/cart-controller.dart';
import 'package:shopping_app/controller/payment-controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/utils/AppConstant.dart';
import 'package:shopping_app/utils/global-variables.dart';

import '../../controller/get-customer-device-token-controller.dart';

class CheckoutScreen extends StatefulWidget {
  bool? selectService;
  CheckoutScreen({this.selectService});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late TextEditingController timeController;
  final payment = PaymentController();
  bool confirmOrder = false;

  @override
  void initState() {
    super.initState();
    timeController = TextEditingController();
    fetchUserData(); // Fetch user data
    fetchAddressData(); // Fetch address data

    // Add a listener to addressController
    addressController.addListener(() {
      setState(() {});
    });
  }

  final CartController cartController = Get.find<CartController>();
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GloablVariableDeclaration globalVariableDeclaration = GloablVariableDeclaration();
  String selectedPaymentMethod = 'Card';

  bool isPaymentCompleted = false;
  bool? service;

  void recieve(bool value) {
    print("recieved valude is $value");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppConstant.colorBlue,
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print("recieved valu is ${widget.selectService}");
              // globalVariableDeclaration.setSelectService(widget.selectService!);
              fetchAddressData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Info',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if(widget.selectService != null && widget.selectService!)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 55.0,
                child: TextFormField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select delivery time',
                    labelText: 'Delivery Time',
                    suffixIcon: IconButton(
                      icon: Icon(Icons
                          .access_time), // Change icon to access_time for time selection
                      onPressed: () async {
                        // Replace this with your time selection logic
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          timeController.text = picked.format(context);
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: selectedPaymentMethod == 'Card',
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod =
                                value! ? 'Card' : 'Cash on Delivery';
                          });
                        },
                      ),
                      Text('Card Payment'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: selectedPaymentMethod == 'Cash on Delivery',
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod =
                                value! ? 'Cash on Delivery' : 'Card';
                          });
                        },
                      ),
                      Text('Cash on Delivery'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  String name = nameController.text.trim();
                  String address = addressController.text.trim();
                  String phone = phoneController.text.trim();
                  String time = timeController.text.trim();
                  String total = cartController.totalPrice.toString();
                  String paymentMethod = selectedPaymentMethod;

                  String? customerToken = await getCustomerDeviceToken();

                  print('Customer Token: $customerToken');
                  print('Name: $name');
                  print('phome : $phone');
                  print('Address: $address');
                  print('Time: $time');
                  print('Payment Method: $paymentMethod');
                  print("Total price: $total");

                  if (selectedPaymentMethod == 'Card') {
                    // Show dialog for card payment confirmation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Card Payment Confirmation'),
                        content: Text(
                            'Are you sure you want to proceed with Card Payment?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Close the dialog
                              // Proceed with card payment
                              if (await payment.makePayment(total)) {
                                await cartController.placeOrder(
                                  cartController.cartItems,
                                  cartController.totalPrice,
                                  user!.uid,
                                  name,
                                  phone,
                                  address,
                                  paymentMethod,
                                  time,
                                );

                                if (isPaymentCompleted) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Order completed with $paymentMethod");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                }
                              }
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Place order for Cash on Delivery directly
                    await cartController.placeOrder(
                      cartController.cartItems,
                      cartController.totalPrice,
                      user!.uid,
                      name,
                      phone,
                      address,
                      paymentMethod,
                      time,
                    );
                    setState(() {
                      isPaymentCompleted = true;
                    });
                    if (isPaymentCompleted) {
                      print("complete");
                      Fluttertoast.showToast(
                          msg: "Order completed with $paymentMethod");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.colorBlue,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
              break;
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

  // Fetch user data
  void fetchUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        print('User data: $userData');
        setState(() {
          nameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = user!.email ?? '';
          // You can add more fields if available in the address collection
        });
      } else {
        print('No data found for this user');
      }
    }).catchError((error) {
      print('Error fetching address data: $error');
    });
  }

  void fetchAddressData() {
    FirebaseFirestore.instance
        .collection('addresses')
        .where('email', isEqualTo: user!.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final addressData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        print('Address data: $addressData');
        setState(() {
          addressController.text = addressData['address'] ?? '';
          // You can add more fields if available in the address collection
        });
      } else {
        print('No data found for this address');
      }
    }).catchError((error) {
      print('Error fetching address data: $error');
    });
  }

  Future<void> sendEmail(String recipient, String subject, String body) async {
    String username = "ealumnimobileapp@gmail.com";
    String password = "NABIL112233";

    print('Sending email to $recipient');

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'UTM E-COMMERCE APP')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
