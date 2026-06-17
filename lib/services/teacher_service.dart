import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherService {
  final supabase = Supabase.instance.client;

  Future<String> getTeacherStatus(
    String userId,
  ) async {
    final user = await supabase
        .from('users')
        .select('teacher_status')
        .eq('id', userId)
        .single();

    return user['teacher_status'] ??
        'Not Available';
  }

  Future<void> updateTeacherStatus({
    required String userId,
    required String status,
  }) async {
    await supabase
        .from('users')
        .update({
          'teacher_status': status,
        })
        .eq('id', userId);
  }

 Future<List<Map<String, dynamic>>>
    searchTeachers(
  String query,
) async {
  final teachers = await supabase
      .from('users')
      .select()
      .eq('role', 'Teacher');

  return List<Map<String, dynamic>>.from(
    teachers.where(
      (teacher) =>
          teacher['name']
              .toString()
              .toLowerCase()
              .contains(
                query.toLowerCase(),
              ) ||
          teacher['register_number']
              .toString()
              .toLowerCase()
              .contains(
                query.toLowerCase(),
              ),
    ),
  );
}
}