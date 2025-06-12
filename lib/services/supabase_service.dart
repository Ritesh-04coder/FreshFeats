// lib/services/supabase_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  final Future<void> _initFuture;

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal() : _initFuture = _initializeSupabase();

  // Internal initialization logic
  static Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    _instance._client = Supabase.instance.client;
    _instance._isInitialized = true;
  }

  // Client getter (async)
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await _initFuture;
    }
    return _client;
  }

  // Synchronous client getter (use only after initialization)
  SupabaseClient get syncClient {
    if (!_isInitialized) {
      throw Exception('Supabase not initialized. Call client getter first.');
    }
    return _client;
  }

  // Auth helpers
  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isAuthenticated => currentUser != null;

  // Auth methods
  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Listen to auth changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Database helpers
  Future<List<dynamic>> selectRows(String table) async {
    try {
      final response = await _client.from(table).select();
      return response;
    } catch (error) {
      throw Exception('Select failed: $error');
    }
  }

  Future<List<dynamic>> insertRow(
      String table, Map<String, dynamic> data) async {
    try {
      final response = await _client.from(table).insert(data).select();
      return response;
    } catch (error) {
      throw Exception('Insert failed: $error');
    }
  }

  Future<List<dynamic>> updateRow(String table, Map<String, dynamic> data,
      String column, dynamic value) async {
    try {
      final response =
          await _client.from(table).update(data).eq(column, value).select();
      return response;
    } catch (error) {
      throw Exception('Update failed: $error');
    }
  }

  Future<List<dynamic>> deleteRow(
      String table, String column, dynamic value) async {
    try {
      final response =
          await _client.from(table).delete().eq(column, value).select();
      return response;
    } catch (error) {
      throw Exception('Delete failed: $error');
    }
  }

  // Realtime subscriptions
  RealtimeChannel subscribeToTable(String table, Function(dynamic) callback) {
    return _client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: callback,
        )
        .subscribe();
  }

  void unsubscribeFromChannel(RealtimeChannel channel) {
    _client.removeChannel(channel);
  }
}
