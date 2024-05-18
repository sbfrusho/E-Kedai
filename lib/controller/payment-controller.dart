// // ignore_for_file: prefer_const_constructors


// import 'dart:convert'; 
  
// import 'package:flutter/material.dart'; 
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:fluttertoast/fluttertoast.dart'; 
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// class PaymentController {
//   Map<String, dynamic>? paymentIntent;
//   Future<void> makePayment() async { 
//     try { 
//       // Create payment intent data 
//       paymentIntent = await createPaymentIntent('10', 'USD'); 
//       // initialise the payment sheet setup 
//       await Stripe.instance.initPaymentSheet( 
//         paymentSheetParameters: SetupPaymentSheetParameters( 
//           // Client secret key from payment data 
//           paymentIntentClientSecret: paymentIntent!['client_secret'], 
//           googlePay: const PaymentSheetGooglePay( 
//               // Currency and country code is accourding to India 
//               testEnv: true, 
//               currencyCode: "USD", 
//               merchantCountryCode: "US"), 
//           // Merchant Name 
//           merchantDisplayName: 'Flutterwings', 
//           // return URl if you want to add 
//           // returnURL: 'flutterstripe://redirect', 
//         ), 
//       ); 
//       // Display payment sheet 
//       displayPaymentSheet(); 
//     } catch (e) { 
//       print("exception $e"); 
  
//       if (e is StripeConfigException) { 
//         print("Stripe exception ${e.message}"); 
//       } else { 
//         print("exception $e"); 
//       } 
//     } 
//   } 
//   displayPaymentSheet() async { 
//     try { 
//       // "Display payment sheet"; 
//       await Stripe.instance.presentPaymentSheet(); 
//       // Show when payment is done 
//       // Displaying snackbar for it 
//       Fluttertoast.showToast(msg: "Payment Done"); 
//       paymentIntent = null; 
//     } on StripeException catch (e) { 
//       // If any error comes during payment  
//       // so payment will be cancelled 
//       print('Error: $e'); 
  
//       Fluttertoast.showToast(msg: "Payment Canceled"); 
//     } catch (e) { 
//       print("Error in displaying"); 
//       print('$e'); 
//     } 
//   } 
//   createPaymentIntent(String amount, String currency) async { 
//     try { 
//       Map<String, dynamic> body = { 
//         'amount': ((int.parse(amount)) * 100).toString(), 
//         'currency': currency, 
//         'payment_method_types[]': 'card', 
//       }; 
//       var secretKey = 
//           "sk_test_51PGXvy06xtEbkBYxTTHTZWSoJDHDj9d8EH6ru6dqmVBpLCrNUohWeMsPZw31SPN3EbdL1rBRH4JGbGhGKZfZbmeL00HI8Zv3T2"; 
//       var response = await http.post( 
//         Uri.parse('https://api.stripe.com/v1/payment_intents'), 
//         headers: { 
//           'Authorization': 'Bearer $secretKey', 
//           'Content-Type': 'application/x-www-form-urlencoded'
//         }, 
//         body: body, 
//       ); 
//       print('Payment Intent Body: ${response.body.toString()}'); 
//       return jsonDecode(response.body.toString()); 
//     } catch (err) { 
//       print('Error charging user: ${err.toString()}'); 
//     } 
//   } 

// }

