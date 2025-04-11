import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import '../const/app_colors.dart';

class HeyloLoading extends StatelessWidget {
  const HeyloLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: SweepGradient(
                    colors: [
                      Colors.purple,
                      Colors.blue,
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.purple,
                    ],
                    startAngle: 0.0,
                    endAngle: 3.14 * 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ).animate(onPlay: (p) => p.repeat()).rotate(duration: 1.seconds),
              Container(
                padding: EdgeInsets.all(6),
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: SvgPicture.asset(
                      'assets/icons/icon.svg',
                      colorFilter: ColorFilter.mode(bgColor, BlendMode.srcIn),
                    )
                    .animate(onPlay: (p) => p.repeat(reverse: true))
                    .scaleXY(begin: 0.9, end: 1.2, duration: 1200.ms),
              ),
            ],
          ),
        ),
        Container(
          height: 36,
          padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 4) +
              EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: LinearGradient(
              colors: [
                primaryColor,
                primaryColor.withValues(alpha: 0.7),
                primaryColor.withValues(alpha: 0.8),
                primaryColor.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
                  'Heylo is thinking...',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    color: bgColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
                .animate(onPlay: (p) => p.repeat(reverse: true))
                .fade(duration: 1200.ms, begin: 0.2, end: 1),
          ),
        ).animate().scaleXY(
          alignment: Alignment.centerLeft,
          duration: 600.ms,
          curve: Curves.easeInOutQuint,
        ),
      ],
    );
  }
}

class MyLoading extends StatelessWidget {
  const MyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: SweepGradient(
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.purple,
                ],
                startAngle: 0.0,
                endAngle: 3.14 * 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent),
              ),
            ),
          ).animate(onPlay: (p) => p.repeat()).rotate(duration: 1.seconds),
          Container(
            padding: EdgeInsets.all(6),
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: SvgPicture.asset(
              'assets/icons/icon.svg',
              colorFilter: ColorFilter.mode(bgColor, BlendMode.srcIn),
            )
                .animate(onPlay: (p) => p.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.2, duration: 1200.ms),
          ),
        ],
      ),
    );
  }
}
