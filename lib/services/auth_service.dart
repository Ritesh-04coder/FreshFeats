import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

// lib/services/auth_service.dart

class AuthService extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  AuthService() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _currentUser = _supabaseService.currentUser;

    // Listen to auth state changes
    _supabaseService.authStateChanges.listen((AuthState state) {
      _currentUser = state.session?.user;
      notifyListeners();

      // Handle auth events
      switch (state.event) {
        case AuthChangeEvent.signedIn:
          _handleSignedIn(state.session?.user);
          break;
        case AuthChangeEvent.signedOut:
          _handleSignedOut();
          break;
        case AuthChangeEvent.userUpdated:
          _handleUserUpdated(state.session?.user);
          break;
        default:
          break;
      }
    });
  }

  // Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _supabaseService.signUp(email, password);

      if (response.user != null) {
        // Create user profile
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
        );
      }
    } catch (error) {
      _setError(error.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _supabaseService.signIn(email, password);
    } catch (error) {
      _setError(_parseAuthError(error.toString()));
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with OAuth (Google, Apple, etc.)
  Future<void> signInWithOAuth(OAuthProvider provider) async {
    try {
      _setLoading(true);
      _clearError();

      final client = await _supabaseService.client;
      await client.auth.signInWithOAuth(provider);
    } catch (error) {
      _setError(error.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _supabaseService.signOut();
    } catch (error) {
      _setError(error.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      final client = await _supabaseService.client;
      await client.auth.resetPasswordForEmail(email);
    } catch (error) {
      _setError(error.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    Map<String, dynamic>? address,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (_currentUser == null) {
        throw Exception('User not authenticated');
      }

      final client = await _supabaseService.client;
      final updateData = <String, dynamic>{};

      if (fullName != null) updateData['full_name'] = fullName;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (address != null) updateData['address'] = address;

      updateData['updated_at'] = DateTime.now().toIso8601String();

      await client
          .from('user_profiles')
          .update(updateData)
          .eq('id', _currentUser!.id);
    } catch (error) {
      _setError(error.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (_currentUser == null) return null;

      final client = await _supabaseService.client;
      final response = await client
          .from('user_profiles')
          .select('*')
          .eq('id', _currentUser!.id)
          .maybeSingle();

      return response;
    } catch (error) {
      print('Failed to fetch user profile: $error');
      return null;
    }
  }

  // Create user profile after sign up
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      final client = await _supabaseService.client;
      await client.from('user_profiles').insert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'preferences': {},
      });
    } catch (error) {
      print('Failed to create user profile: $error');
      // Don't throw here as auth was successful
    }
  }

  // Handle sign in event
  void _handleSignedIn(User? user) {
    _currentUser = user;
    _clearError();
    print('User signed in: ${user?.email}');
  }

  // Handle sign out event
  void _handleSignedOut() {
    _currentUser = null;
    _clearError();
    print('User signed out');
  }

  // Handle user updated event
  void _handleUserUpdated(User? user) {
    _currentUser = user;
    print('User updated: ${user?.email}');
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _parseAuthError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password. Please try again.';
    } else if (error.contains('User already registered')) {
      return 'An account with this email already exists.';
    } else if (error.contains('weak_password')) {
      return 'Password is too weak. Please choose a stronger password.';
    } else if (error.contains('invalid_email')) {
      return 'Please enter a valid email address.';
    }
    return 'Authentication failed. Please try again.';
  }

  void clearError() {
    _clearError();
  }
}
