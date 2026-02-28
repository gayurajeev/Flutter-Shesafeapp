import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/facility_provider.dart';
import 'providers/user_provider.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FacilityProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const SheSafeApp(),
    ),
  );
}

class SheSafeApp extends StatelessWidget {
  const SheSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SheSafe',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFE91E63),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          primary: const Color(0xFFE91E63),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}