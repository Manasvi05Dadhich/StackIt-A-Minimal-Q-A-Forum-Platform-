import 'package:flutter/material.dart';
import 'package:stackit/mob/mobile_layout.dart';
import 'package:stackit/web/ask_question_screen.dart';
import 'package:stackit/web/home_screen.dart';
import 'package:stackit/web/sign_up_page.dart';
import 'package:stackit/web/web_layout.dart';
import 'package:stackit/web/web_login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'WorkSans'),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),

        // '/': (context) => ResponsiveHome(),
        '/login': (context) => WebLoginScreen(),
        '/SignUp': (context) => SignUpPage(),
        '/AskQuestionScreen': (context) => AskQuestionScreen(),
      },
    );
  }
}

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return MobileLayout();
    } else {
      return WebLayout();
    }
  }
}
