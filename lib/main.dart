import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_stack/screens/home_screen.dart';
import 'package:green_stack/screens/notifications_screen.dart';
import 'package:green_stack/screens/otp_screen.dart';
import 'package:green_stack/screens/product_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/status_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ required before async init
  await dotenv.load(fileName: ".env");       // ✅ ensure the file exists
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroBridge',
      theme: ThemeData(textTheme: GoogleFonts.outfitTextTheme()),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/signup': (_) => const SignUpScreen(),
        '/login': (_) => const LoginScreen(),
        '/otp': (_) => const OtpScreen(),
        '/home': (_) => const HomeScreen(),
        '/status': (_) => StatusScreen(),
        '/cart': (_) => CartScreen(),
        '/settings': (_) => SettingsScreen(),
        '/profile': (_) => ProfileScreen(),
        '/product': (_) => const ProductScreen(),
        '/notifications': (_) => const NotificationsScreen(),
      },
    );
  }
}
