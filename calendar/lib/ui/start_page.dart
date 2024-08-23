import 'package:calendar/ui/login_page.dart';
import 'package:calendar/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import for SVG support
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
                // Top Row with App Title and Logo
                FadeInUp(
                  duration: const Duration(seconds: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Title with animation
                      SlideInLeft(
                        duration: const Duration(seconds: 2),
                        
                        child: Text(
                          '  AI  \nCalendar',
                          textAlign:
                              TextAlign.right, // Align text to the right side
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: white, // primaryClr
                              ),
                        ),
                      ),
                      const SizedBox(width: 20), // Space between text and logo

                      

                      // App Logo with animation
                      BounceInRight(
                        duration: const Duration(seconds: 2),
                        child: SvgPicture.asset(
                          'images/orange-logo.svg', // Use your SVG file here
                          width: isWideScreen ? 120 : 75,
                          height: isWideScreen ? 120 : 75,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height: 20), // Space between top row and description

                // Description with animation
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
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
                const SizedBox(
                    height: 30), // Space between description and button

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
                        ),
                        backgroundColor: primaryClr, // primaryClr
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
