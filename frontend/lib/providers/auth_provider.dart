import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await AuthService.storage.read(key: 'token');
      
      if (token != null) {
        final response = await _authService.getCurrentUser();
        
        if (response != null && 
            response['success'] == true && 
            response['user'] != null && 
            response['user'] is Map<String, dynamic>) {
          _currentUser = User.fromJson(response['user']);
          _isAuthenticated = true;
          _error = null;
        } else {
          _isAuthenticated = false;
          _error = response?['message'] ?? 'Failed to get user data';
        }
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      _error = 'Initialization error: ${e.toString()}';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
        role: role,
      );

      if (response != null && 
          response['success'] == true && 
          response['user'] != null) {
        _currentUser = User.fromJson(response['user']);
        _isAuthenticated = true;
        _error = null;
        return true;
      } else {
        _error = response?['message'] ?? 'Registration failed';
        return false;
      }
    } catch (e) {
      _error = 'Registration error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    print('AuthProvider.login() called with email: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        _error = 'Please enter both email and password';
        print('Login error: $_error');
        return false;
      }

      print('Calling _authService.login()');
      final response = await _authService.login(
        email: email.trim(),
        password: password.trim(),
      );

      print('AuthService response: $response');

      // More robust null and type checking
      if (response == null) {
        _error = 'No response from server';
        print('Login error: $_error');
        return false;
      }

      if (response['success'] == true) {
        print('Login successful, processing user data');
        
        try {
          // Create a minimal user object if user data is missing
          if (response['user'] == null) {
            print('No user data in response, creating minimal user object');
            _currentUser = User(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              email: email,
              fullName: email.split('@').first,
              username: email.split('@').first,
            );
          } else if (response['user'] is Map) {
            final userData = Map<String, dynamic>.from(response['user']);
            print('Processing user data: $userData');
            
            // Ensure required fields are present
            userData['id'] = userData['_id']?.toString() ?? 'unknown_id';
            userData['email'] = userData['email'] ?? email;
            userData['fullName'] = userData['fullName'] ?? email.split('@').first;
            userData['username'] = userData['username'] ?? email.split('@').first;
            
            _currentUser = User.fromJson(userData);
          } else {
            print('Unexpected user data format: ${response['user']}');
            _currentUser = User(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              email: email,
              fullName: email.split('@').first,
              username: email.split('@').first,
            );
          }
          
          _isAuthenticated = true;
          _error = null;
          print('User successfully authenticated: ${_currentUser?.email}');
          return true;
          
        } catch (e, stackTrace) {
          print('Error processing user data: $e');
          print('Stack trace: $stackTrace');
          
          // Create a minimal user object on error
          _currentUser = User(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            email: email,
            fullName: email.split('@').first,
            username: email.split('@').first,
          );
          _isAuthenticated = true;
          _error = null;
          return true;
        }
        
      } else {
        _error = response['message']?.toString() ?? 
                response['error']?.toString() ?? 
                'Login failed. Please check your credentials and try again.';
        print('Login failed: $_error');
        return false;
      }
      
    } catch (e, stackTrace) {
      _error = 'An error occurred during login: ${e.toString()}';
      print('Login exception: $_error');
      print('Stack trace: $stackTrace');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
      print('Login process completed. Success: ${_isAuthenticated}');
      if (_error != null) {
        print('Error: $_error');
      }
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = 'Logout error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}