import 'package:flutter/material.dart';
import '../services/teacher_service.dart';
import '../services/location_db_service.dart';

import 'teacher_location_screen.dart';
class TeacherFinderScreen extends StatefulWidget {
  const TeacherFinderScreen({
    super.key,
  });

  @override
  State<TeacherFinderScreen> createState() =>
      _TeacherFinderScreenState();
}

class _TeacherFinderScreenState
    extends State<TeacherFinderScreen> {
  final teacherService =
      TeacherService();
final locationDbService =
    LocationDbService();
  final searchController =
      TextEditingController();

  List<Map<String, dynamic>>
      teachers = [];

  Future<void> searchTeacher() async {
    final result =
        await teacherService
            .searchTeachers(
      searchController.text,
    );

    setState(() {
      teachers = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Find Teacher'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
           TextField(
  controller: searchController,
  decoration: InputDecoration(
    labelText: 'Search Teacher',
    border: const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        searchController.clear();

        setState(() {
          teachers = [];
        });
      },
    ),
  ),
),

            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
              onPressed:
                  searchTeacher,
              child: const Text(
                'Search',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: ListView.builder(
                itemCount:
                    teachers.length,
                itemBuilder:
                    (context, index) {
                  final teacher =
                      teachers[index];

                  return Card(
  margin: const EdgeInsets.only(
    bottom: 10,
  ),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          teacher['name'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Role: ${teacher['role']}',
        ),

        const SizedBox(height: 5),

        Text(
          'Status: ${teacher['teacher_status']}',
        ),

        const SizedBox(height: 10),

        teacher['teacher_status'] ==
                'Available'
            ? Align(
                alignment:
                    Alignment.centerRight,
                child:
                    ElevatedButton.icon(
                  onPressed: () async {
                    final location =
                        await locationDbService
                            .getLocationByUserId(
                      teacher['id'],
                    );

                    if (location ==
                        null) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TeacherLocationScreen(
                          teacherName:
                              teacher[
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
                  icon: const Icon(
                    Icons.map,
                  ),
                  label: const Text(
                    'View Map',
                  ),
                ),
              )
            : const Text(
                'Location Unavailable',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
      ],
    ),
  ),
);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}