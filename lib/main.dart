import 'package:flutter/material.dart';
import 'features/iam/login_screen.dart';
import 'theme/colors.dart';

void main() {
  runApp(const AylluCareApp());
}

class AylluCareApp extends StatelessWidget {
  const AylluCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AylluCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.lightBlue,
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textBlue),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
