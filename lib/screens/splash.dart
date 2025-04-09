import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home/homepage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _navigate() {
    Future.delayed(const Duration(milliseconds: 2600), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1100),
          pageBuilder:
              (context, animation, secondaryAnimation) => const Homepage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void initState() {
    _navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'splash',
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/icons/left.png',
                height: 200,
                width: 200,
              ).animate().scaleXY(
                alignment: Alignment.topLeft,
                delay: 200.ms,
                curve: Curves.easeInOutQuint,
                duration: 1200.ms,
              ),
              Image.asset(
                'assets/icons/right.png',
                height: 200,
                width: 200,
              ).animate().scaleXY(
                alignment: Alignment.bottomRight,
                delay: 200.ms,
                curve: Curves.easeInOutQuint,
                duration: 1200.ms,
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index) {
                      final delay = (index * 90).ms;
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                              height: 13,
                              width:
                                  index == 0
                                      ? 120
                                      : index == 1
                                      ? 90
                                      : index == 2
                                      ? 70
                                      : 105,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color:
                                    index == 0 || index == 2
                                        ? Color(0xFFfca311)
                                        : Color(0xFF14213d),
                              ),
                            )
                            .animate(delay: 1200.ms)
                            .scaleXY(
                              alignment: Alignment.centerLeft,
                              delay: delay,
                              curve: Curves.easeInOutQuint,
                              duration: 1200.ms,
                            ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
