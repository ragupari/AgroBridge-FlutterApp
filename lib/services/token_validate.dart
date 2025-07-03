// token_validate.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';
  
  // Check if token is valid
  static Future<bool> checkTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    if (token == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}/auth/validate'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        // Token expired, try to refresh
        return await _refreshToken();
      }
      
      return false;
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }
  
  // Refresh token
  static Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(_refreshTokenKey);
    
    if (refreshToken == null) return false;
    
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_BASE_URL']}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString(_tokenKey, data['access_token']);
        
        // Update refresh token if provided
        if (data['refresh_token'] != null) {
          await prefs.setString(_refreshTokenKey, data['refresh_token']);
        }
        
        return true;
      }
    } catch (e) {
      print('Token refresh error: $e');
    }
    
    return false;
  }
  
  // Save tokens after login
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }
  
  // Get current token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Logout - clear tokens
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}

// Keep backward compatibility
Future<bool> checkTokenValid() async {
  return await AuthService.checkTokenValid();
}