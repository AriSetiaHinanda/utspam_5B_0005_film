import 'package:flutter/material.dart';
import 'package:cinebook/presentation/pages/auth/login_page.dart';
import 'package:cinebook/core/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:cinebook/presentation/providers/auth_provider.dart';
import 'package:cinebook/presentation/providers/film_provider.dart';
import 'package:cinebook/presentation/providers/transaction_provider.dart';
import 'package:cinebook/presentation/providers/theme_provider.dart';
import 'package:cinebook/data/repositories/user_repository.dart';
import 'package:cinebook/data/repositories/film_repository.dart';
import 'package:cinebook/data/repositories/transaction_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            userRepository: UserRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FilmProvider(
            filmRepository: FilmRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(
            transactionRepository: TransactionRepository(),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          title: 'CineBook',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}