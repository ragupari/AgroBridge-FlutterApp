import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiBase = dotenv.env['API_BASE_URL'] ?? '';

class AuthService {
  // 🔐 Register user
  static Future<Map<String, dynamic>> registerUser({
    required String firstname,
    required String lastname,
    required String mobile,
  }) async {
    final url = Uri.parse('$apiBase/auth/registerDemo');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'mobile': mobile,
        }),
      );

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') == true) {
        final data = jsonDecode(response.body);
        return {'status': 200, 'data': data};
      } else {
        return {
          'status': response.statusCode,
          'data': {'success': false, 'message': 'Invalid response format'}
        };
      }
    } catch (e) {
      print('Error in registerUser: $e');
      return {
        'status': 500,
        'data': {'success': false, 'message': 'Server error'}
      };
    }
  }

  // 🔓 Login user by mobile only
  static Future<Map<String, dynamic>> loginUser({required String mobile}) async {
    final url = Uri.parse('$apiBase/auth/loginDemo'); // adjust route as needed

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobile}),
      );

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') == true) {
        final data = jsonDecode(response.body);
        return {'status': 200, 'data': data};
      } else {
        return {
          'status': response.statusCode,
          'data': {'success': false, 'message': 'Not a registered mobile number'}
        };
      }
    } catch (e) {
      print('Error in loginUser: $e');
      return {
        'status': 500,
        'data': {'success': false, 'message': 'Server error'}
      };
    }
  }
}
