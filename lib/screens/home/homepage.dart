import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late AnimationController buttonController;
  final color = Color(0xFF14213d);

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(vsync: this, duration: 60.ms);
    controller = AnimationController(vsync: this, duration: 1.seconds);
    animation = Tween<double>(begin: 6.0, end: 1.6).animate(buttonController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heylo', style: GoogleFonts.bungee()),
        leading: IconButton(
          onPressed: () {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else {
              controller.forward();
            }
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: controller,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to Heylo!',
                    style: GoogleFonts.bungee(fontSize: 20),
                  ),
                  Text(
                    "What's on your mind today?",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 12,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Hero(
                        tag: 'splash',
                        child: SvgPicture.asset(
                          'assets/icons/icon.svg',
                          height: 36,
                          width: 36,
                        ),
                      ),

                      Expanded(
                        child: CupertinoTextField(
                          placeholder: 'Ask me anything...',
                          placeholderStyle: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          cursorColor: Color(0xFF14213d),
                          cursorHeight: 15,
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF14213d),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFeaf4f4),
                            border: Border.all(color: Color(0xFF14213d)),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: 200.ms,
                        height: 40,
                        width: 40,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFF14213d),
                        ),
                        child: Center(
                          child: Transform.translate(
                            offset: Offset(0, 2),
                            child: Transform.rotate(
                              angle: 49.5,
                              child: Icon(
                                CupertinoIcons.paperplane_fill,
                                size: 18,
                                color: Color(0xFFeaf4f4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Top Left
          Positioned(
            top: -50,
            left: -10,
            child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: color,
                  ),
                )
                .animate(autoPlay: false, controller: controller)
                .scaleXY(
                  alignment: Alignment.topLeft,
                  end: 6,
                  duration: 800.ms,
                  curve: Curves.easeInOutCirc,
                ),
          ),
          // Top Right
          Positioned(
            top: -60,
            right: -60,
            child: Container(
                  height: 100,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: color,
                  ),
                )
                .animate(autoPlay: false, controller: controller)
                .scaleXY(
                  alignment: Alignment.topRight,
                  end: 5,
                  duration: 800.ms,
                  curve: Curves.easeInOutCirc,
                ),
          ),
          //
          // // Bottom Left
          Positioned(
            left: -300,
            bottom: 0,
            child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: color,
                  ),
                )
                .animate(autoPlay: false, controller: controller)
                .scaleXY(
                  alignment: Alignment.bottomLeft,
                  end: 6,
                  duration: 800.ms,
                  curve: Curves.easeInOutCirc,
                ),
          ),
          // // Bottom Right
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
                  height: 100,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: color,
                  ),
                )
                .animate(autoPlay: false, controller: controller)
                .scaleXY(
                  alignment: Alignment.bottomRight,
                  end: 5,
                  duration: 800.ms,
                  curve: Curves.easeInOutCirc,
                ),
          ),
        ],
      ),
    );
  }
}
