import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntent;

  Future<bool> makePayment(String amount) async {
    try {
      // Create payment intent data
      paymentIntent = await createPaymentIntent(double.parse(amount), 'MYR'); // Changed to MYR
      // Initialise the payment sheet setup
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Client secret key from payment data
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
            testEnv: true,
            currencyCode: "MYR", // Changed to MYR
            merchantCountryCode: "MY", // Changed to Malaysia
          ),
          merchantDisplayName: 'Flutterwings',
          // returnURL: 'flutterstripe://redirect',
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
    } on StripeException catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Payment Cancelled");
    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(double amount, String currency) async {
  try {
    // Convert the amount to the smallest currency unit (e.g., cents for USD)

    print("This is a double value :$amount");
    int amountInCents = (amount * 100).toInt();

    Map<String, dynamic> body = {
      'amount': amountInCents.toString(),
      'currency': currency,
      'payment_method_types[]': 'card',
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

}
