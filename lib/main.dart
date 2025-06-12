import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/custom_error_widget.dart';
import 'core/app_export.dart';

// lib/main.dart

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  final supabaseService = SupabaseService();
  await supabaseService.client; // Ensure initialization

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: Sizer(builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'foodtracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.initial,
        );
      }),
    );
  }
}
