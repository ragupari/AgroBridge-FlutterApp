import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  customInputField(Icons.phone, "Enter Mobile Number"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/otp');
                      },
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have an Account? "),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/signup'),
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

  // Widget socialButton(String text, IconData icon) {
  //   return ElevatedButton.icon(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.green[100],
  //       foregroundColor: Colors.black,
  //       minimumSize: const Size(double.infinity, 40),
  //     ),
  //     onPressed: () {},
  //     icon: Icon(icon),
  //     label: Text(text),
  //   );
  // }
}
