import 'package:easyol/firebase_options.dart'; // ඔබේ ව්‍යාපෘතියට අදාළව මෙය නිවැරදි දැයි බලන්න
import 'package:easyol/provider/auth_provider.dart';
import 'package:easyol/screens/auth/loginpage.dart';
import 'package:easyol/screens/mainWrapper.dart';

import 'package:easyol/screens/auth/registerpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase නිවැරදිව Initialize කිරීම
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyOL',
      theme: ThemeData(primarySwatch: Colors.blue),
      // මුලින්ම පෙන්විය යුතු පිටුව ලෙස LoginPage එක සැකසීම
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) => const MainWrapper(),
      },
    );
  }
}
