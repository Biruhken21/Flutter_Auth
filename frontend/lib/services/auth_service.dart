import 'dart:convert' show jsonDecode, utf8;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  // Base URL for API
  static const String _baseUrl = 'http://localhost:5000/api'; // Use localhost for testing
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static FlutterSecureStorage get storage => _storage;

  // Register user
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Empty response from server',
        };
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['token'] != null) {
        // Save token
        await storage.write(key: 'token', value: responseData['token']);
        
        // Parse and return user
        return {
          'success': true,
          'user': User.fromJson(responseData['user']),
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e != null ? 'Network error: ${e.toString()}' : 'Network error occurred',
      };
    }
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('Login attempt with email: $email');
    try {
      if (email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Email and password are required',
        };
      }

      print('Sending login request to $_baseUrl/auth/login');
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );

      // Log response details for debugging
      print('Login Response Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      // Handle empty response
      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Empty response from server',
        };
      }

      // Parse response
      final Map<String, dynamic> responseData;
      try {
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        responseData = decodedBody is Map ? Map<String, dynamic>.from(decodedBody) : {};
        print('Successfully parsed response data');
      } catch (e) {
        print('Error parsing response: $e');
        return {
          'success': false,
          'message': 'Invalid server response format: ${e.toString()}',
        };
      }

      // Handle successful login
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          if (responseData['token'] != null) {
            // Save token
            final token = responseData['token'].toString();
            print('Saving token: ${token.substring(0, 10)}...');
            await storage.write(key: 'token', value: token);
            
            // Parse and return user
            if (responseData['user'] != null) {
              try {
                final userData = responseData['user'] is Map 
                    ? responseData['user'] 
                    : {'id': 'unknown', 'email': email};
                    
                print('User data found in response');
                return {
                  'success': true,
                  'user': userData,
                };
              } catch (e) {
                print('Error processing user data: $e');
                return {
                  'success': true, // Still success since token is valid
                  'user': {'email': email},
                };
              }
            }
            
            // If we have a token but no user data, still return success
            return {
              'success': true,
              'user': {'email': email},
            };
          }
          
          return {
            'success': false,
            'message': 'Authentication token not found in response',
          };
        }
        
        // Handle case where success is false
        return {
          'success': false,
          'message': responseData['error']?.toString() ?? 'Authentication failed',
        };
      }
      
      // Handle error responses
      return {
        'success': false,
        'message': responseData['message']?.toString() ?? 
                  responseData['error']?.toString() ?? 
                  'Login failed (Status: ${response.statusCode})',
      };
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.message}',
      };
    } on FormatException catch (e) {
      return {
        'success': false,
        'message': 'Data parsing error: ${e.message}',
      };
    } on Exception catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await storage.read(key: 'token');
      
      if (token == null) {
        return {
          'success': false,
          'message': 'No token found',
        };
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Empty response from server',
        };
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['data'] != null) {
        return {
          'success': true,
          'user': User.fromJson(responseData['data']),
        };
      } else {
        // Token might be expired or invalid
        await storage.delete(key: 'token');
        return {
          'success': false,
          'message': responseData['error'] ?? 'Failed to get user data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      final token = await storage.read(key: 'token');
      
      if (token != null) {
        // Call logout endpoint
        await http.get(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
      
      // Delete token regardless of API response
      await storage.delete(key: 'token');
      return true;
    } catch (e) {
      // Still try to delete token on error
      await storage.delete(key: 'token');
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }
}
