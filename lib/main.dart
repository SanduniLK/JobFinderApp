import 'package:flutter/material.dart';
import 'package:job_finder/presentation/provider/auth_provider.dart';
import 'package:job_finder/presentation/provider/heme_provider.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/core/themes/app_theme.dart';

import 'package:job_finder/presentation/screens/splash_screen.dart';
import 'package:job_finder/presentation/screens/signin_screen.dart';
import 'package:job_finder/presentation/screens/signup_step1_screen.dart';
import 'package:job_finder/presentation/screens/signup_step2_screen.dart';
import 'package:job_finder/presentation/screens/signup_step3_screen.dart';
import 'package:job_finder/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Job Finder',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/signin': (context) => const SignInScreen(),
              '/signup/step1': (context) => const SignUpStep1Screen(),
              '/signup/step2': (context) => const SignUpStep2Screen(),
              '/signup/step3': (context) => const SignUpStep3Screen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}