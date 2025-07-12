import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stackit/components/custom_main.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero illustration
            Lottie.asset('assets/animation/welcome.json', height: 260),
            const SizedBox(height: 40),

            // Logo icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset('assets/logo.png', width: 36, height: 36),
              ),
            ),
            const SizedBox(height: 24),

            // App name
            const Text(
              'StackIt',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 32),

            // Tagline
            const Text(
              'Ask. Answer. Grow. Together on StackIt.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'A minimal Q&A platform for collaborative learning.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
            ),
            const SizedBox(height: 40),

            // Get Started Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/SignUp');
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login text
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Already have an account? Log in',
                style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
