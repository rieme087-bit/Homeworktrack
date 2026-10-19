import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homework_tracker/views/login_screen.dart/login_screen.dart';
import 'views/main_navigation.dart';

const _ink = Color(0xFF111111);
const _paper = Color(0xFFFFFFFF);
const _canvas = Color(0xFFF7F7F7);
const _muted = Color(0xFF737373);
const _outline = Color(0xFFE5E5E5);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomeworkTrackerApp());
}

class HomeworkTrackerApp extends StatelessWidget {
  const HomeworkTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework Tracker',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: _ink,
          onPrimary: _paper,
          secondary: Color(0xFF404040),
          onSecondary: _paper,
          surface: _paper,
          onSurface: _ink,
          error: _ink,
          onError: _paper,
        ),
        scaffoldBackgroundColor: _canvas,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: _canvas,
          foregroundColor: _ink,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: _ink,
          ),
        ),
        cardTheme: CardThemeData(
          color: _paper,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _outline),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _paper,
          selectedItemColor: _ink,
          unselectedItemColor: _muted,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _ink,
            foregroundColor: _paper,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: _ink),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: _ink,
          foregroundColor: _paper,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _paper,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _ink, width: 1.5),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: _ink),
      ),
      home: const SplashScreen(),
    ); // MaterialApp
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: _canvas,
            body: Center(
              child: Text(
                'Homework Tracker',
                style: TextStyle(
                  fontSize: 28,
                  color: _ink,
                  fontWeight: FontWeight.bold,
                ), // TextStyle
              ), // Text
            ), // Center
          ); // Scaffold
        }
        // If user is signed in
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        // If user is not signed in
        return const LoginScreen();
      },
    ); // StreamBuilder
  }
}