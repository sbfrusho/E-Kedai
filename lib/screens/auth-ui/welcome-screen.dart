import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/screens/auth-ui/forgot-password-screen.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/select-service.dart';
import '../../controller/get-user-data-controller.dart';
import '../../controller/sign-in-controller.dart';
import 'register-screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // add a media query to get the screen size
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          //Add a back button to left of the app bar
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue,
                  Colors.yellow,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(
                      "assets/images/img_shopping_cart_1.png",
                    ),
                    width: 200,
                    height: 200,
                  ),
                  const Text(
                    'Welcome TO E-KEDAI',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'A new shopping experience.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Login to continue',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  LoginForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Text("here"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(
              () => TextFormField(
                controller: passwordController,
                obscureText: signInController.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      signInController.isPasswordVisible.toggle();
                    },
                    child: signInController.isPasswordVisible.value
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen()));
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String email = emailController.text.trim();
              String password = passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                showToast(context, "All fields are required");
              } else {

                UserCredential? userCredential =
                    await signInController.signInMethod(email, password);

                String? whoLoggedIn = "";

                var userData = getUserDataController.getUserData(userCredential!.user!.uid);

                // print("Hello Wrold ------ >>>>>>>>");
                // print(userData);
                // print("End ---------- ......>>>>>>>>>>>>");

                // ignore: unnecessary_null_comparison
                if (userCredential != null) {
                  if (userCredential.user!.emailVerified) {

                    showToast(context, "Login $whoLoggedIn Successful");

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));

                        
                    return; // Return here to prevent showing unnecessary toasts or snackbar
                  } else {
                    showToast(context, "Please verify your email before login");
                  }
                } else {
                  showToast(context, "Login failed. Please try again.");
                }
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

//create a toast message for the login
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