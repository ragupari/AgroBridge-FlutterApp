import 'package:flutter/material.dart';
import 'package:green_stack/screens/otp_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer Login',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/signup': (_) => const SignUpScreen(),
        '/login': (_) => const LoginScreen(),
        '/otp': (_) => const OtpScreen(),
      },
    );
  }
}
