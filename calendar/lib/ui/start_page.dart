import 'package:calendar/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // darkGreyClr
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo with animation
                FadeInUp(
                  duration: const Duration(seconds: 2),
                  child: BounceInDown(
                    duration: const Duration(seconds: 2),
                    child: Container(
                      width: isWideScreen ? 200 : 150,
                      height: isWideScreen ? 200 : 150,
                      child: Image.asset('images/profile.png'), // Use your image here
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // App Title with animation
                FadeInUp(
                  duration: const Duration(seconds: 2),
                  child: SlideInUp(
                    duration: const Duration(seconds: 2),
                    child: Text(
                      'Smart Calendar',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4e5ae8), // primaryClr
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description with animation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FadeInUp(
                    duration: const Duration(seconds: 2),
                    child: SlideInUp(
                      duration: const Duration(seconds: 2),
                      child: Text(
                        'Transform your daily routine with Smart Calendar: Capture task photos, receive intelligent timing suggestions, and seamlessly manage your productivity with our intuitive app.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: isWideScreen ? 18 : 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Get Started Button with animation
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: BounceInUp(
                    duration: const Duration(seconds: 2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isWideScreen ? 20 : 15,
                          horizontal: isWideScreen ? 40 : 30,
                        ), backgroundColor: const Color(0xFF4e5ae8), // primaryClr
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () {
                        Get.to(LoginPage());  
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
