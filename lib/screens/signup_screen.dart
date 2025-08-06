// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

 Future<void> handleRegister() async {
  // Optional: show a loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  final response = await AuthService.registerUser(
    firstname: _firstNameCtrl.text.trim(),
    lastname: _lastNameCtrl.text.trim(),
    mobile: _mobileCtrl.text.trim(),
  );

  Navigator.of(context).pop(); // Hide loading dialog

  // Check if registration was successful
  if (response['data']['success']) {
   ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response['data']['message'] ?? 'Registration successful',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        dismissDirection: DismissDirection.up,
      ),
    );

    // Navigate to OTP screen
    Navigator.pushNamed(context, '/otp');
  } else {
    // Show error message in SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response['data']['message'] ?? 'Registration failed',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        dismissDirection: DismissDirection.up,
      ),
    );
  }
}


  Widget customInputField(IconData icon, String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: AppColors.paleGreen),
        boxShadow: [
          BoxShadow(
            color: AppColors.paleGreen.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(icon),
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Top area with image
          Expanded(
            child: Center(
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  'images/AgroBridge.png',
                  height: MediaQuery.of(context).size.width * 0.80,
                  fit: BoxFit.contain,
                 
                ),
              ),
            ),
          ),

          // Bottom-aligned form
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 30),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: AppColors.paleGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1600),
                    child: customInputField(Icons.person, "Enter First Name", _firstNameCtrl),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1700),
                    child: customInputField(Icons.person, "Enter Last Name", _lastNameCtrl),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: customInputField(Icons.phone, "Enter Mobile Number", _mobileCtrl),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: MaterialButton(
                      onPressed: handleRegister,
                      color: AppColors.paleGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 50,
                      minWidth: double.infinity,
                 child: const Center(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                        
                      ),
                    ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text(
                          "Already Have an Account? Login",
                          style: TextStyle(color: AppColors.paleGreen),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
