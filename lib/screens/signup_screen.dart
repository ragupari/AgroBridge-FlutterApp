import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Discover a Better Way to Shop—Sign Up & Connect\nWith Farmers!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  customInputField(Icons.person, "Enter First Name"),
                  const SizedBox(height: 15),
                  customInputField(Icons.person, "Enter Last Email"),
                  const SizedBox(height: 15),
                  customInputField(Icons.phone, "Enter Mobile Number"),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 200, // Set desired width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/otp');
                      },
                      child: const Text("Sign Up"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already Have an Account? "),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Text(
                          "Login Here",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customInputField(
    IconData icon,
    String hint, {
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.green[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
