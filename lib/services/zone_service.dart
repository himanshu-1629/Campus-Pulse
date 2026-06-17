import 'package:supabase_flutter/supabase_flutter.dart';

class ZoneService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getZones() async {
    final response = await supabase
        .from('zones')
        .select();

    return List<Map<String, dynamic>>.from(
      response,
    );
  }
}