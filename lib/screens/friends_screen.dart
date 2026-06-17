import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/friend_service.dart';
import '../services/location_db_service.dart';
import 'friend_location_screen.dart';
class FriendsScreen extends StatefulWidget {
  final String userId;

  const FriendsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final registerController = TextEditingController();
final locationDbService =
    LocationDbService();
  final authService = AuthService();
  final friendService = FriendService();

  Map<String, dynamic>? searchedUser;
String friendshipStatus = 'none';
String? expandedFriendId;
  List<Map<String, dynamic>> sentRequests = [];
List<Map<String, dynamic>> incomingRequests = [];
List<Map<String, dynamic>> friends = [];
  @override
  @override
void initState() {
  super.initState();
  loadAllData();
}
Future<void> loadAllData() async {
  final sent = await friendService.getSentRequests(
    widget.userId,
  );

  final incoming =
      await friendService.getIncomingRequests(
    widget.userId,
  );

  final accepted =
      await friendService.getFriends(
    widget.userId,
  );

  setState(() {
    sentRequests = sent;
    incomingRequests = incoming;
    friends = accepted;
  });
}
  Future<void> loadSentRequests() async {
    final requests =
        await friendService.getSentRequests(
      widget.userId,
    );

    setState(() {
      sentRequests = requests;
    });
  }

Future<void> searchUser() async {
  final user = await authService
      .searchUserByRegisterNumber(
    registerController.text.trim(),
  );

  String status = 'none';

  if (user != null) {
    status = await friendService
        .getFriendshipStatus(
      currentUserId: widget.userId,
      otherUserId: user['id'],
    );
  }

  setState(() {
    searchedUser = user;
    friendshipStatus = status;
  });
}

Future<void> sendRequest() async {
  if (searchedUser == null) return;

  await friendService.sendFriendRequest(
    senderId: widget.userId,
    receiverId: searchedUser!['id'],
  );
await loadAllData();

  registerController.clear();

  setState(() {
    searchedUser = null;
  });

  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Friend Request Sent',
        ),
      ),
    );
  }
}
  Future<void> cancelRequest(
    String requestId,
  ) async {
    await friendService.cancelRequest(
      requestId,
    );

    await loadAllData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Request Cancelled',
          ),
        ),
      );
    }
  }
  Future<void> acceptRequest(
  String requestId,
) async {
  await friendService.acceptRequest(
    requestId,
  );

  await loadAllData();
}

Future<void> rejectRequest(
  String requestId,
) async {
  await friendService.rejectRequest(
    requestId,
  );

  await loadAllData();
}

  @override
  void dispose() {
    registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            TextField(
  controller: registerController,
  decoration: InputDecoration(
    labelText: 'Register Number',
    border: const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        registerController.clear();

        setState(() {
          searchedUser = null;
          friendshipStatus = 'none';
        });
      },
    ),
  ),
),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: searchUser,
              child: const Text('Search'),
            ),

            const SizedBox(height: 20),

            if (searchedUser != null)
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                        title: Text(
                          searchedUser!['name'],
                        ),
                        subtitle: Text(
                          searchedUser![
                              'register_number'],
                        ),
                        trailing: Text(
                          searchedUser!['role'],
                        ),
                      ),

                   SizedBox(
  width: double.infinity,
  child: friendshipStatus == 'accepted'
      ? const Chip(
          label: Text(
            'Already Friends',
          ),
        )
      : friendshipStatus == 'pending'
          ? const Chip(
              label: Text(
                'Request Pending',
              ),
            )
          : ElevatedButton(
              onPressed: sendRequest,
              child: const Text(
                'Send Friend Request',
              ),
            ),
),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 15),

            const Text(
              'Pending Requests Sent',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (sentRequests.isEmpty)
              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(16),
                  child: Text(
                    'No pending requests',
                  ),
                ),
              ),
...sentRequests.map(
  (request) => Card(
    child: ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(
        request['name'] ?? 'Unknown User',
      ),
      subtitle: Text(
        request['register_number'] ?? '',
      ),
     trailing: SizedBox(
  width: 100,
  child: ElevatedButton(
    onPressed: () => cancelRequest(
      request['id'],
    ),
    child: const Text('Cancel'),
  ),
),
    ),
  ),
),
            const SizedBox(height: 30),

            const Text(
              'Incoming Requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

           if (incomingRequests.isEmpty)
  const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'No incoming requests',
      ),
    ),
  ),

...incomingRequests.map(
  (request) => Card(
    child: ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(
        request['name'],
      ),
      subtitle: Text(
        request['register_number'],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
            onPressed: () =>
                acceptRequest(
              request['id'],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            onPressed: () =>
                rejectRequest(
              request['id'],
            ),
          ),
        ],
      ),
    ),
  ),
),

            const SizedBox(height: 30),

            const Text(
              'My Friends',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (friends.isEmpty)
  const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'No friends yet',
      ),
    ),
  ),
...friends.map(
  (friend) => Card(
    child: InkWell(
      borderRadius:
          BorderRadius.circular(12),
      onTap: () {
        setState(() {
          if (expandedFriendId ==
              friend['id']) {
            expandedFriendId = null;
          } else {
            expandedFriendId =
                friend['id'];
          }
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Column(
          children: [

            Row(
              children: [

                const CircleAvatar(
                  child: Icon(
                    Icons.person,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        friend['name'],
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      Text(
                        friend[
                            'register_number'],
                      ),
                    ],
                  ),
                ),

                Text(
                  friend['role'],
                ),
              ],
            ),

            if (expandedFriendId ==
                friend['id']) ...[

              const SizedBox(
                height: 15,
              ),

              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton.icon(
                  icon: const Icon(
                    Icons.map,
                  ),
                  label: const Text(
                    'View On Map',
                  ),
                  onPressed:
                      () async {

                    final location =
                        await locationDbService
                            .getLocationByUserId(
                      friend['id'],
                    );

                    if (location ==
                        null) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FriendLocationScreen(
                          friendName:
                              friend[
                                  'name'],
                          latitude:
                              location[
                                  'latitude'],
                          longitude:
                              location[
                                  'longitude'],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}