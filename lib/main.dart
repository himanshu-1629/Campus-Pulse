import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  final prefs =
      await SharedPreferences.getInstance();

  final expiry =
      prefs.getInt('sessionExpiry');

  Widget startScreen =
      const LoginScreen();

  if (expiry != null &&
      DateTime.now()
              .millisecondsSinceEpoch <
          expiry) {

    await prefs.setInt(
      'sessionExpiry',
      DateTime.now()
          .add(
            const Duration(hours: 6),
          )
          .millisecondsSinceEpoch,
    );

    startScreen = HomeScreen(
      userId:
          prefs.getString('userId')!,
      name:
          prefs.getString('name')!,
      role:
          prefs.getString('role')!,
    );
  }

  runApp(
    MyApp(
      startScreen: startScreen,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({
    super.key,
    required this.startScreen,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startScreen,
    );
  }
}