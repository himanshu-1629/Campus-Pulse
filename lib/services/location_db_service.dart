import 'package:supabase_flutter/supabase_flutter.dart';

class LocationDbService {
  final supabase = Supabase.instance.client;

  Future<void> updateLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    await supabase.from('locations').upsert({
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllLocations() async {
    final response = await supabase
        .from('locations')
        .select();

    return List<Map<String, dynamic>>.from(
      response,
    );
  }
  Future<Map<String, dynamic>> getUserInfo(
  String userId,
) async {
  final response = await supabase
      .from('users')
      .select(
  'name,role,teacher_status',
)
      .eq('id', userId)
      .single();

  return response;
}
Future<Map<String, dynamic>?> getLocationByUserId(
  String userId,
) async {
  final response = await supabase
      .from('locations')
      .select()
      .eq('user_id', userId)
      .maybeSingle();

  return response;
}
}