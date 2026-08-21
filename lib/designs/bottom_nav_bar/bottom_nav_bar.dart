import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final List<String> icons = [
    "assets/svg/trophy.svg",
    "assets/svg/swords.svg",
    "assets/svg/user.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 35),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: RadialGradient(
          radius: 4,
          colors: [
            Colors.cyanAccent.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          return NavItems(
            svgPath: icons[index],
            isSelected: widget.currentIndex == index,
            onTap: () {
              setState(() {
                widget.onTap(index);
              });
            },
          );
        }),
      ),
    );
  }
}

class NavItems extends StatefulWidget {
  final String svgPath;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItems({
    super.key,
    required this.svgPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavItems> createState() => _NavItemsState();
}

class _NavItemsState extends State<NavItems>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotation;
  double scale = 1.0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    rotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.2, end: -0.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -0.2, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  void handleTap() {
    widget.onTap();

    controller.forward(from: 0);

    setState(() => scale = 1.3);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => scale = 1.0);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleTap,
      child: AnimatedBuilder(
        animation: rotation,
        builder: (context, child) {
          return Transform.rotate(
            angle: rotation.value,
            child: AnimatedScale(
              scale: widget.isSelected ? 1.3 : scale,
              duration: const Duration(seconds: 6),
              curve: Curves.easeOutBack,
              child: SvgPicture.asset(
                widget.svgPath,
                height: 26,
                colorFilter: ColorFilter.mode(
                  widget.isSelected
                      ? Colors.cyanAccent.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
