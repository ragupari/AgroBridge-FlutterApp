import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_stack/screens/home_screen.dart';
import 'package:green_stack/screens/join_screen.dart';
import 'package:green_stack/screens/notifications_screen.dart';
import 'package:green_stack/screens/otp_screen.dart';
import 'package:green_stack/screens/product_screen.dart';
import 'package:green_stack/screens/product_selling_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/status_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/token_validate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Check authentication status
  bool isAuthenticated = await checkTokenValid();

  runApp(MyApp(isAuthenticated: isAuthenticated));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroBridge',
      theme: ThemeData(textTheme: GoogleFonts.outfitTextTheme()),
      debugShowCheckedModeBanner: false,
      initialRoute: isAuthenticated ? '/home' : '/join',
      routes: {
        '/signup': (_) => const SignUpScreen(),
        '/login': (_) => const LoginScreen(),
        '/otp': (_) => const OtpScreen(),
        '/home': (_) => const AuthGuard(child: HomeScreen()),
        '/status': (_) => AuthGuard(child: StatusScreen()),
        '/cart': (_) => AuthGuard(child: CartScreen()),
        '/settings': (_) => AuthGuard(child: SettingsScreen()),
        '/profile': (_) => AuthGuard(child: ProfileScreen()),
        '/product': (_) => const AuthGuard(child: ProductScreen()),
        '/notifications': (_) => const AuthGuard(child: NotificationsScreen()),
        '/join': (_) => const JoinScreen(),
        '/sell-product': (_) => const AuthGuard(child: ProductSellingScreen()),
      },
    );
  }
}

// Auth Guard Widget to protect routes
class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isValid = await checkTokenValid();
    setState(() {
      _isAuthenticated = isValid;
      _isLoading = false;
    });

    if (!isValid) {
      // Token is invalid, redirect to login
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/join', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isAuthenticated) {
      // This shouldn't happen due to redirect, but just in case
      return const Scaffold(
        body: Center(child: Text('Please log in to continue')),
      );
    }

    return widget.child;
  }
}
