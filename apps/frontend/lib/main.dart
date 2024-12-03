import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/initial_page.dart';
import 'package:frontend/register/major.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await firebase_auth.FirebaseAuth.instance.signInAnonymously();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MajorProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialPage(),
    );
  }
}
