import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/My%20Cart/my_cart_view.dart';
import 'package:shopping_app/controller/cart-controller.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntent;
  String? customerId; 
  CartController cartController = Get.put(CartController());


  Future<bool> makePayment(String amount) async {
    try {
      // Create or retrieve customer
      customerId = await createOrRetrieveCustomer();

      // Create payment intent data
      paymentIntent = await createPaymentIntent(double.parse(amount), 'MYR', customerId!); // Changed to MYR

      // Initialise the payment sheet setup
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          customerId: customerId,
          googlePay: const PaymentSheetGooglePay(
            testEnv: true,
            currencyCode: "MYR", // Changed to MYR
            merchantCountryCode: "MY", // Changed to Malaysia
          ),
          merchantDisplayName: 'Flutterwings',
        ),
      );

      // Display payment sheet
      await displayPaymentSheet();
      return true;
    } catch (e) {
      print("exception $e");
      if (e is StripeConfigException) {
        print("Stripe exception ${e.message}");
      } else {
        print("exception $e");
      }
    }
    return false;
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar("Success", "Paid successfully");
      paymentIntent = null;
      Get.offAll(CartScreen());
      cartController.clearCart();
    } on StripeException catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Payment Cancelled");
    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(double amount, String currency, String customerId) async {
    try {
      int amountInCents = (amount * 100).toInt();

      Map<String, dynamic> body = {
        'amount': amountInCents.toString(),
        'currency': currency,
        'customer': customerId,
        'payment_method_types[]': 'card',
        'setup_future_usage': 'off_session' // This line tells Stripe to save the card for future use
      };

      var secretKey = "sk_test_51PGXvy06xtEbkBYxTTHTZWSoJDHDj9d8EH6ru6dqmVBpLCrNUohWeMsPZw31SPN3EbdL1rBRH4JGbGhGKZfZbmeL00HI8Zv3T2";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      print('Payment Intent Body: ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      print('Error charging user: ${err.toString()}');
      rethrow;
    }
  }

  Future<String> createOrRetrieveCustomer() async {
    // Here you should implement logic to retrieve a customer ID from your server
    // If the customer does not exist, create a new customer in Stripe

    // For the sake of this example, we'll assume a new customer is created each time
    // In a real application, you should store and retrieve the customer ID

    try {
      var secretKey = "sk_test_51PGXvy06xtEbkBYxTTHTZWSoJDHDj9d8EH6ru6dqmVBpLCrNUohWeMsPZw31SPN3EbdL1rBRH4JGbGhGKZfZbmeL00HI8Zv3T2";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {},
      );

      var customer = jsonDecode(response.body.toString());
      print('Customer created: ${customer['id']}');
      return customer['id'];
    } catch (err) {
      print('Error creating customer: ${err.toString()}');
      rethrow;
    }
  }
}
