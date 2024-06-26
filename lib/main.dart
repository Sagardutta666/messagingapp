import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messagingapp/services/auth/auth_gate.dart';
import 'package:messagingapp/themes/theme_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Connectopia',
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: const AuthGate(),
      ),
    );
  }
}
