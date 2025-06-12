import 'custom_inspector.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/custom_error_widget.dart';
import 'core/app_export.dart';

// lib/main.dart

var backendURL = "https://foodtracke6763back.builtwithrocket.new/log-error";

void main() async {
  FlutterError.onError = (details) {
    _sendOverflowError(details);
  };
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
            return CustomWidgetInspector(
            // isInspectorEnabled: isInspectionRunning == 'true',
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            ) // Preserve original MediaQuery content
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


    void _sendOverflowError(FlutterErrorDetails details) {
      try {
        final errorMessage = details.exception.toString();
        final exceptionType = details.exception.runtimeType.toString();

        String location = 'Unknown';
        final locationMatch = RegExp(r'file:///.*\.dart').firstMatch(details.toString());
        if (locationMatch != null) {
          location = locationMatch.group(0)?.replaceAll("file://", '') ?? 'Unknown';
        }
        String errorType = "RUNTIME_ERROR";
        if(errorMessage.contains('overflowed by') || errorMessage.contains('RenderFlex overflowed')) {
          errorType = 'OVERFLOW_ERROR';
        }
        final payload = {
          'errorType': errorType,
          'exceptionType': exceptionType,
          'message': errorMessage,
          'location': location,
          'timestamp': DateTime.now().toIso8601String(),
        };
        final jsonData = jsonEncode(payload);
        final request = html.HttpRequest();
        request.open('POST', backendURL, async: true);
        request.setRequestHeader('Content-Type', 'application/json');
        request.onReadyStateChange.listen((_) {
          if (request.readyState == html.HttpRequest.DONE) {
            if (request.status == 200) {
              print('Successfully reported error');
            } else {
              print('Error reporting overflow');
            }
          }
        });
        request.onError.listen((event) {
          print('Failed to send overflow report');
        });
        request.send(jsonData);
      } catch (e) {
        print('Exception while reporting overflow error: $e');
      }
    }
    