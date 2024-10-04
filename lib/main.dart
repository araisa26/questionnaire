import 'package:flutter/material.dart';
import 'package:questionnaire/config/app_color.dart';
import 'package:questionnaire/screen/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: AppColors.blue,
        ),
        scaffoldBackgroundColor: AppColors.blue,
        cardColor: Colors.white,
        primaryColor: AppColors.blue,
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: AppColors.darkgray),
        ),
        disabledColor: AppColors.lightgray,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      home: const HomeScreen(),
    );
  }
}
