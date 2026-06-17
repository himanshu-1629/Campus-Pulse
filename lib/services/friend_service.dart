import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FriendService {
  final supabase = Supabase.instance.client;
Future<String> getFriendshipStatus({
  required String currentUserId,
  required String otherUserId,
}) async {
  final friendships = await supabase
      .from('friendships')
      .select()
      .or(
        'and(sender_id.eq.$currentUserId,receiver_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,receiver_id.eq.$currentUserId)',
      );

  if (friendships.isEmpty) {
    return 'none';
  }

  final friendship = friendships.first;

  if (friendship['status'] == 'accepted') {
    return 'accepted';
  }

  if (friendship['status'] == 'pending') {
    return 'pending';
  }

  return 'none';
}
  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
  }) async {
    await supabase.from('friendships').insert({
      'id': const Uuid().v4(),
      'sender_id': senderId,
      'receiver_id': receiverId,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> getSentRequests(
    String userId,
  ) async {
    final requests = await supabase
        .from('friendships')
        .select()
        .eq('sender_id', userId)
        .eq('status', 'pending');

    List<Map<String, dynamic>> result = [];

    for (final request in requests) {
      final user = await supabase
          .from('users')
          .select()
          .eq('id', request['receiver_id'])
          .single();

      result.add({
        ...request,
        'name': user['name'],
        'register_number': user['register_number'],
        'role': user['role'],
      });
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getIncomingRequests(
    String userId,
  ) async {
    final requests = await supabase
        .from('friendships')
        .select()
        .eq('receiver_id', userId)
        .eq('status', 'pending');

    List<Map<String, dynamic>> result = [];

    for (final request in requests) {
      final user = await supabase
          .from('users')
          .select()
          .eq('id', request['sender_id'])
          .single();

      result.add({
        ...request,
        'name': user['name'],
        'register_number': user['register_number'],
        'role': user['role'],
      });
    }

    return result;
  }

  Future<void> acceptRequest(
    String requestId,
  ) async {
    await supabase
        .from('friendships')
        .update({
          'status': 'accepted',
        })
        .eq('id', requestId);
  }

  Future<void> rejectRequest(
    String requestId,
  ) async {
    await supabase
        .from('friendships')
        .delete()
        .eq('id', requestId);
  }

  Future<List<Map<String, dynamic>>> getFriends(
    String userId,
  ) async {
    final friendships = await supabase
        .from('friendships')
        .select()
        .eq('status', 'accepted');

    List<Map<String, dynamic>> result = [];

    for (final friendship in friendships) {
      String? friendId;

      if (friendship['sender_id'] == userId) {
        friendId = friendship['receiver_id'];
      } else if (friendship['receiver_id'] == userId) {
        friendId = friendship['sender_id'];
      }

      if (friendId == null) continue;

      final user = await supabase
          .from('users')
          .select()
          .eq('id', friendId)
          .single();

      result.add({
        'id': user['id'],
        'name': user['name'],
        'register_number': user['register_number'],
        'role': user['role'],
      });
    }

    return result;
  }

  Future<void> cancelRequest(
    String requestId,
  ) async {
    await supabase
        .from('friendships')
        .delete()
        .eq('id', requestId);
  }
}