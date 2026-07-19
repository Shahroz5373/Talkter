import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const GlassMorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  static const double _blurStrength = 14.0;
  //static const double _borderRadius = 25.0;
  static const double _borderWidth = 1.2;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurStrength, sigmaY: _blurStrength),
        child: Container(
          width: width, // null → sizes to child
          height: height, // null → sizes to child
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use the actual width (if constrained) for the rim highlight
              final containerWidth = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  // Main glass body
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: _borderWidth,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: child,
                    ),
                  ),
                  // Top rim highlight – now respects dynamic width
                  if (containerWidth > 0)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2.5,
                        margin: EdgeInsets.symmetric(
                          horizontal: containerWidth * 0.08,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
