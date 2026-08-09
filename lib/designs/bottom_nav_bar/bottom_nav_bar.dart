import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:talkter/designs/bottom_nav_bar/model/nav_item_model.dart';

const Color nav_bar_bg = Color(0xFF17203A);

class CustomBottomNavBar extends StatefulWidget {
  final Function(int index) onPageIndexChanged;
  const CustomBottomNavBar({super.key, required this.onPageIndexChanged});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];
  int selectedNavIndex = 0;

  void animateIcons({required int index}) {
    riveIconInputs[index].change(true);
    Future.delayed(Duration(seconds: 1), () {
      riveIconInputs[index].change(false);
    });
  }

  void riveOnInit({
    required Artboard artboard,
    required String stateMachineName,
  }) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );
    artboard.addController(controller!);
    controllers.add(controller);
    riveIconInputs.add(controller.findInput<bool>("active") as SMIBool);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: nav_bar_bg.withValues(alpha: 0.8),
          borderRadius: BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: nav_bar_bg.withValues(alpha: 0.3),
              offset: Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomNavItems.length, (index) {
            final riveIcon = bottomNavItems[index].rive;
            return GestureDetector(
              onTap: () {
                animateIcons(index: index);
                setState(() {
                  selectedNavIndex = index;
                });
                widget.onPageIndexChanged(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBar(isActive: selectedNavIndex == index),
                  SizedBox(
                    height: 31,
                    width: 40,
                    child: Opacity(
                      opacity: selectedNavIndex == index ? 1 : 0.5,
                      child: RiveAnimation.asset(
                        riveIcon.src,
                        artboard: riveIcon.artboard,
                        onInit: (artboard) {
                          riveOnInit(
                            artboard: artboard,
                            stateMachineName: riveIcon.stateMachineName,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({super.key, required this.isActive});
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
