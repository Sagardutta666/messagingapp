// ignore: file_names
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:messagingapp/services/auth/auth_service.dart';
import 'package:messagingapp/components/button.dart';
import 'package:messagingapp/components/textfield.dart';

class LoginPage extends StatelessWidget {
// email and pass text controllers

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController_ = TextEditingController();

  //tap to go login page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  //login method
  Future<void> login(BuildContext context) async {
    // Check if the email field is empty
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Return early to prevent further execution
    }

    // Check if the password field is empty
    if (_passwordController_.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Return early to prevent further execution
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
            child: CircularProgressIndicator(color: Colors.purple));
      },
    );

    final authService = AuthService();

    // Proceed with login attempt if both fields are filled
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController_.text);

      // Dismiss the loading dialog
      Navigator.pop(context);

      // On successful login, navigate to the next page or show a success message
      // Navigate to next screen or show success message here
    } catch (e) {
      // Dismiss the loading dialog
      Navigator.pop(context);

      // If login fails, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('User does not exist. Please create your account first.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset(
                    'assets/animations/login_animation.json',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              //welcome message
              const Text(
                "Welcome Back, you have been missed!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              //Email textfield
              MyTextField(
                controller: _emailController,
                hintText: " Email",
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 10,
              ),

              MyTextField(
                controller: _passwordController_,
                hintText: " Password",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 25,
              ),

              // login button

              MyButton(
                onTap: () => login(context),
                text: "Login",
              ),

              const SizedBox(
                height: 25,
              ),

              // register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Register now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
