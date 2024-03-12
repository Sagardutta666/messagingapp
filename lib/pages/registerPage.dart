import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:messagingapp/services/auth/auth_service.dart';

import '../components/button.dart';
import '../components/textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  void register(BuildContext context) async {
    // Check if any field is empty
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_confirmpasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if passwords match
    if (_passwordController.text != _confirmpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if the password meets the format requirements
    if (!isPasswordCompliant(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password does not meet requirements'),
          backgroundColor: Colors.red,
        ),
      );
      return;
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

    final _auth = AuthService();

    try {
      await _auth.signUpWithEmailPassword(
          _emailController.text, _passwordController.text);

      // Dismiss the loading dialog
      Navigator.pop(context);

      // Navigate to the login screen or home screen after successful sign up
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Dismiss the loading dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool isPasswordCompliant(String password, {int minLength = 8}) {
    // Define what constitutes a compliant password, e.g., minimum length, at least one number, one letter, and one special character
    bool hasMinLength = password.length >= minLength;
    bool hasNumber = password.contains(RegExp(r'\d'));
    bool hasLetter = password.contains(RegExp(r'[A-Za-z]'));
    bool hasSpecialCharacter =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasMinLength && hasNumber && hasLetter && hasSpecialCharacter;
  }

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset(
                    'assets/animations/registration_animation.json',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              //welcome message
              Text(
                "Let's create an account for you!! :)",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
              ),

              const SizedBox(
                height: 10,
              ),

              MyTextField(
                controller: _passwordController,
                hintText: " Password",
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),

              MyTextField(
                controller: _confirmpasswordController,
                hintText: "Confirm Password",
                obscureText: true,
              ),

              const SizedBox(
                height: 25,
              ),

              // login button

              MyButton(
                onTap: () => register(context),
                text: "Register",
              ),

              const SizedBox(
                height: 25,
              ),

              // register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Login now",
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
