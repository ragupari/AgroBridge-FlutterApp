import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
    final response = await AuthService.registerUser(
      firstname: _firstNameCtrl.text,
      lastname: _lastNameCtrl.text,
      mobile: _mobileCtrl.text,
    );

    if (response['status'] == 200 && response['data']['success']) {
      Navigator.pushNamed(context, '/otp');
      print("Registration successful: ${response['data']['message']}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
        response['data']['message'] ?? 'Error',
        style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        // Show from the top
        dismissDirection: DismissDirection.up,
      ),
      );
    }
  }

  Widget customInputField(
      IconData icon, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.green[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign Up", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 20),
            customInputField(Icons.person, "Enter First Name", _firstNameCtrl),
            const SizedBox(height: 15),
            customInputField(Icons.person, "Enter Last Name", _lastNameCtrl),
            const SizedBox(height: 15),
            customInputField(Icons.phone, "Enter Mobile Number", _mobileCtrl),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.white,
              ),
              
              child: const Text("Sign Up"),
            ),
            const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already Have an Account? "),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Text(
                          "Sign Up Here",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
