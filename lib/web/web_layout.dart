import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stackit/components/custom_main.dart';

class WebLayout extends StatelessWidget {
  const WebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Optional illustration - remove this Expanded if you don’t want image
              Expanded(
                child: Lottie.asset(
                  'assets/animation/welcome.json', // Add an illustration or remove this widget
                  height: 360,
                ),
              ),
              const SizedBox(width: 80),

              // Welcome content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + App Name
                    Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
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
                            child: Image.asset(
                              'assets/logo.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'StackIt',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Tagline
                    const Text(
                      'Ask. Answer. Grow. Together on StackIt.',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'A minimal Q&A platform for collaborative learning.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
                    ),
                    const SizedBox(height: 40),

                    // Get Started button
                    SizedBox(
                      width: 200,
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
                          // Navigate to login page
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

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
