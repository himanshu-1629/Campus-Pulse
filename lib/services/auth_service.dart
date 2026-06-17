import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> registerUser({
    required String name,
    required String email,
    required String registerNumber,
    required String password,
    required String role,
  }) async {
    await supabase.from('users').insert({
      'id': const Uuid().v4(),
      'name': name,
      'email': email,
      'register_number': registerNumber,
      'password': password,
      'role': role,
    });
  }

  Future<Map<String, dynamic>?> loginUser({
    required String registerNumber,
    required String password,
  }) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('register_number', registerNumber)
        .eq('password', password)
        .maybeSingle();

    return response;
  }

  Future<Map<String, dynamic>?> searchUserByRegisterNumber(
    String registerNumber,
  ) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('register_number', registerNumber)
        .maybeSingle();

    return response;
  }

  Future<bool> resetPassword({
    required String registerNumber,
    required String email,
    required String newPassword,
  }) async {
    final user = await supabase
        .from('users')
        .select()
        .eq('register_number', registerNumber)
        .eq('email', email)
        .maybeSingle();

    if (user == null) {
      return false;
    }

    await supabase
        .from('users')
        .update({
          'password': newPassword,
        })
        .eq(
          'register_number',
          registerNumber,
        );

    return true;
  }
}