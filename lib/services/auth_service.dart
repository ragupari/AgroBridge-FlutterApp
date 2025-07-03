import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiBase = dotenv.env['API_BASE_URL'] ?? '';

class AuthService {
  // 🔐 Register user
 static Future<Map<String, dynamic>> registerUser({
  required String firstname,
  required String lastname,
  required String mobile,
}) async {
  final url = Uri.parse('$apiBase/auth/register');
  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'firstname': firstname,
            'lastname': lastname,
            'mobile': mobile,
          }),
        )
        .timeout(const Duration(seconds: 10));

    // Check if response is JSON
    if (response.headers['content-type']?.contains('application/json') == true) {
      final data = jsonDecode(response.body);

      // If success, save values to SharedPreferences
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('userID', data['user']['userID'].toString());
        await prefs.setString('mobile', data['user']['mobile']);

        return {
          'status': response.statusCode,
          'data': {
            'success': true,
            'message': data['message'] ?? 'Registration successful'
          }
        };
      } else {
        return {
          'status': response.statusCode,
          'data': {
            'success': false,
            'message': data['message'] ?? 'Registration failed'
          }
        };
      }
    } else {
      return {
        'status': response.statusCode,
        'data': {
          'success': false,
          'message': 'Invalid response format'
        }
      };
    }
  } catch (e) {
    print('Error in registerUser: $e');
    return {
      'status': 500,
      'data': {
        'success': false,
        'message': 'Server error'
      }
    };
  }
}

// 🔓 Login user by mobile only
static Future<Map<String, dynamic>> loginUser({required String mobile}) async {
  final url = Uri.parse('$apiBase/auth/login');

  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'mobile': mobile}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.headers['content-type']?.contains('application/json') == true) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('userID', data['user']['userID'].toString());
        await prefs.setString('mobile', data['user']['mobile']);

        return {'status': response.statusCode, 'data': data};
      } else {
        return {
          'status': response.statusCode,
          'data': {
            'success': false,
            'message': data['message'] ?? 'Login failed',
          }
        };
      }
    } else {
      return {
        'status': response.statusCode,
        'data': {
          'success': false,
          'message': 'Invalid response format',
        }
      };
    }
  } catch (e) {
    print('Error in loginUser: $e');
    return {
      'status': 500,
      'data': {
        'success': false,
        'message': 'Server error',
      }
    };
  }
}


  // 🔊 Logout user
  static Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ❓ Check if logged in
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
}
