import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final registerController = TextEditingController();
  final passwordController = TextEditingController();
  final locationService =
    LocationService();
final authService = AuthService();
  @override
  @override
@override
@override
@override
void initState() {
  super.initState();

  WidgetsBinding.instance
      .addPostFrameCallback(
    (_) async {

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission ==
              LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {

        showLocationDialog();
      }
    },
  );
}
Future<void> showLocationDialog() async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(28),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [

            Container(
              height: 80,
              width: 80,
              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF1E40AF),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                        40),
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 42,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Enable Location',
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'Campus Pulse uses your location to provide live campus navigation, teacher discovery, friend tracking and crowd analytics.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                      12),
              decoration:
                  BoxDecoration(
                color: Colors.blue
                    .shade50,
                borderRadius:
                    BorderRadius.circular(
                        16),
              ),
              child: const Column(
                children: [

                  Row(
                    children: [
                      Icon(
                        Icons.map,
                        color:
                            Colors.blue,
                      ),
                      SizedBox(
                          width: 8),
                      Text(
                          'Live Campus Maps'),
                    ],
                  ),

                  SizedBox(
                      height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons
                            .person_search,
                        color:
                            Colors.blue,
                      ),
                      SizedBox(
                          width: 8),
                      Text(
                          'Teacher Finder'),
                    ],
                  ),

                  SizedBox(
                      height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color:
                            Colors.blue,
                      ),
                      SizedBox(
                          width: 8),
                      Text(
                          'Friend Tracking'),
                    ],
                  ),

                  SizedBox(
                      height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.groups,
                        color:
                            Colors.blue,
                      ),
                      SizedBox(
                          width: 8),
                      Text(
                          'Crowd Analytics'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Row(
              children: [

                Expanded(
                  child:
                      OutlinedButton(
                    style:
                        OutlinedButton
                            .styleFrom(
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        false,
                      );
                    },
                    child:
                        const Text(
                      'Later',
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child:
                      ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical:
                            14,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        true,
                      );
                    },
                    child:
                        const Text(
                      'Enable',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  if (result == true) {
    await locationService
        .getCurrentLocation();
  }
}
Future<void> preloadLocation() async {
  try {
    await locationService
        .getCurrentLocation();
  } catch (_) {}
}

Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 70,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Campus Pulse',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Real-Time Campus Intelligence',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: registerController,
                      decoration: InputDecoration(
                        labelText: 'Register Number',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                   TextField(
  controller: passwordController,
  obscureText: !isPasswordVisible,
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: const Icon(
      Icons.lock,
    ),
    suffixIcon: IconButton(
      icon: Icon(
        isPasswordVisible
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          isPasswordVisible =
              !isPasswordVisible;
        });
      },
    ),
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15),
    ),
  ),
),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    15),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final user =
                                await authService
                                    .loginUser(
                              registerNumber:
                                  registerController
                                      .text
                                      .trim(),
                              password:
                                  passwordController
                                      .text
                                      .trim(),
                            );

                            if (user != null) {
                              if (mounted) {
                                final prefs =
    await SharedPreferences.getInstance();

await prefs.setString(
  'userId',
  user['id'],
);

await prefs.setString(
  'name',
  user['name'],
);

await prefs.setString(
  'role',
  user['role'],
);

await prefs.setInt(
  'sessionExpiry',
  DateTime.now()
      .add(const Duration(hours: 6))
      .millisecondsSinceEpoch,
);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HomeScreen(
                                      userId:
                                          user['id'],
                                      name:
                                          user['name'],
                                      role:
                                          user['role'],
                                    ),
                                  ),
                                );
                              }
                            } else {
                              if (mounted) {
                                showDialog(
  context: context,
  builder: (_) => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: Padding(
      padding:
          const EdgeInsets.all(20),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [

          const CircleAvatar(
            radius: 35,
            backgroundColor:
                Colors.red,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 35,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(
            'Login Failed',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            'Invalid Register Number or Password.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style:
                  ElevatedButton
                      .styleFrom(
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child:
                  const Text('OK'),
            ),
          ),
        ],
      ),
    ),
  ),
);
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                SnackBar(
                                  content:
                                      Text(e.toString()),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RegisterScreen(),
                              ),
                            );
                          },
                          child:
                              const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}