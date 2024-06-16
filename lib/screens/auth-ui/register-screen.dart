import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '/screens/auth-ui/welcome-screen.dart';
import 'package:flutter/material.dart';
import '../../controller/sign-up-controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: mediaQuery.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue,
                  Colors.yellow,
                ],
              ),
            ),
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/img_shopping_cart_1.png"),
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Register TO E-KEDAI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final SignUpController registerController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => TextFormField(
                  controller: passwordController,
                  obscureText: !registerController.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        registerController.isPasswordVisible.toggle();
                      },
                      child: Icon(
                        registerController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String name = nameController.text.trim();
                  String email = emailController.text.trim();
                  String phone = phoneController.text.trim();
                  String password = passwordController.text.trim();
                  String deviceToken = '';

                  try {
                    // Call the registration method
                    UserCredential? userCredential =
                        await registerController.signUpMethod(
                      name,
                      email,
                      phone,
                      password,
                      deviceToken,
                    );

                    if (userCredential != null) {
                      showToast(context,
                          "Registration successful. Verify your email to login.");

                      // Clear the text fields
                      nameController.clear();
                      emailController.clear();
                      phoneController.clear();
                      passwordController.clear();

                      // Sign out the current user (if any)
                      await FirebaseAuth.instance.signOut();

                      // Navigate to welcome screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    }
                  } catch (e) {
                    print("Registration failed: $e");
                    showToast(context, "Registration failed. Please try again later.");
                  }
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

void showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    ),
  );
}
