import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../const/app_colors.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String imagePath;

  const MenuButton({
    super.key,
    required this.onTap,
    this.text = "Heylo",
    this.imagePath = 'assets/icons/github.svg',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: secondaryColor,
              blurRadius: 6,
              spreadRadius: .5,
              offset: Offset(.2, .2),
            ),
          ],
          gradient: LinearGradient(
            colors: [secondaryColor, bgColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          height: 50,
          width: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: primaryColor,
          ),
          child: Center(
            child: Row(
              spacing: 10,
              children: [
                SvgPicture.asset(
                  imagePath,
                  colorFilter: ColorFilter.mode(bgColor, BlendMode.srcIn),
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFeaf4f4),
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
