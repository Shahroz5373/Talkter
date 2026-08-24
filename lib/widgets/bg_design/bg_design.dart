import 'package:flutter/material.dart';

class BGDesign extends StatelessWidget {
  const BGDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B2027), Color(0xFF1B3038), Color(0xFF2A4B5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        Positioned(
          top: -25,
          left: -55,
          child: Container(
            height: 260,
            width: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.cyanAccent.withValues(alpha: 0.65),
                  Colors.cyan.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 100,
          right: -50,
          child: Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFCCFF00).withValues(alpha: 0.7),
                  const Color(0xFFCCFF00).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -50,
          right: -60,
          child: Container(
            height: 280,
            width: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF2D95).withValues(alpha: 0.6), // vivid pink
                  const Color(0xFFFF2D95).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 130,
          left: 2,
          child: Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(
                    0xFFFFB800,
                  ).withValues(alpha: 0.7), // bright amber
                  const Color(0xFFFFB800).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          left: MediaQuery.of(context).size.width * 0.15,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.85),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          right: 30,
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.cyanAccent.withValues(alpha: 0.95),
                  Colors.cyanAccent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
