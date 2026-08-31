import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassMessageTile extends StatelessWidget {
  final String message;
  final String time;
  final bool isSender;

  const GlassMessageTile({
    super.key,
    required this.message,
    required this.time,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: CustomPaint(
          // 1. The Painter draws the glowing borders, shadows, and top highlight
          painter: _BubblePainter(isSender: isSender),
          // 2. The Clipper cuts the background blur into the bubble shape
          child: ClipPath(
            clipper: _BubbleClipper(isSender: isSender),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: EdgeInsets.only(
                  left: isSender ? 16 : 24, // Extra padding for the left tail
                  right: isSender ? 24 : 16, // Extra padding for the right tail
                  top: 12,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isSender
                        ? [
                            Colors.cyanAccent.withValues(alpha: 0.2),
                            Colors.cyanAccent.withValues(alpha: 0.05),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.15),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isSender) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 14,
                            color: Colors.cyanAccent.withValues(alpha: 0.8),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- SHARED PATH LOGIC ---
// This ensures the clipping and the borders align flawlessly.
Path _getBubblePath(Size size, bool isSender) {
  final path = Path();
  const double r = 16.0; // Corner radius
  const double t = 10.0; // Tail size
  final double w = size.width;
  final double h = size.height;

  if (isSender) {
    // Tail on Top Right
    path.moveTo(r, 0);
    path.lineTo(w, 0); // Tip of tail
    path.lineTo(w - t, t); // Inner tail corner
    path.lineTo(w - t, h - r);
    path.quadraticBezierTo(w - t, h, w - t - r, h);
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
  } else {
    // Tail on Top Left
    path.moveTo(0, 0); // Tip of tail
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);
    path.lineTo(t + r, h);
    path.quadraticBezierTo(t, h, t, h - r);
    path.lineTo(t, t); // Inner tail corner
    path.lineTo(0, 0);
  }
  return path..close();
}

// --- CLIPPER ---
class _BubbleClipper extends CustomClipper<Path> {
  final bool isSender;
  _BubbleClipper({required this.isSender});

  @override
  Path getClip(Size size) => _getBubblePath(size, isSender);

  @override
  bool shouldReclip(_BubbleClipper oldClipper) =>
      isSender != oldClipper.isSender;
}

// --- PAINTER FOR BORDER & HIGHLIGHT ---
class _BubblePainter extends CustomPainter {
  final bool isSender;
  _BubblePainter({required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    final path = _getBubblePath(size, isSender);

    // 1. Draw Drop Shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.25), 8.0, true);

    // 2. Draw Glass Border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isSender
            ? [
                Colors.cyanAccent.withValues(alpha: 0.5),
                Colors.cyanAccent.withValues(alpha: 0.1),
              ]
            : [
                Colors.white.withValues(alpha: 0.4),
                Colors.white.withValues(alpha: 0.1),
              ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, borderPaint);

    // 3. Draw your custom top highlight/sparkle
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          isSender
              ? Colors.cyanAccent.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.7),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 2.5));

    // Position the highlight perfectly across the flat top edge, avoiding the tail
    const double t = 10.0;
    if (isSender) {
      canvas.drawLine(
        Offset(size.width * 0.15, 1),
        Offset(size.width * 0.85 - t, 1),
        highlightPaint,
      );
    } else {
      canvas.drawLine(
        Offset(t + size.width * 0.15, 1),
        Offset(size.width * 0.85, 1),
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) =>
      isSender != oldDelegate.isSender;
}

class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;

  const SwipeToReply({super.key, required this.child, required this.onReply});

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0.0;

  // How far you must swipe to trigger the reply
  final double _replyThreshold = 60.0;
  // Maximum pixel distance the tile can be dragged
  final double _maxDragDistance = 80.0;

  @override
  void initState() {
    super.initState();
    // Handles the spring-back animation when the user lets go
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 250),
        )..addListener(() {
          setState(() {
            _dragExtent = _controller.value;
          });
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;

      // Prevent swiping left (only allow rightward pull)
      if (_dragExtent < 0) _dragExtent = 0;

      // Add friction if pulled past the max distance
      if (_dragExtent > _maxDragDistance) {
        _dragExtent = _maxDragDistance + (details.delta.dx * 0.1);
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Trigger the reply action if pulled far enough
    if (_dragExtent >= _replyThreshold) {
      HapticFeedback.lightImpact(); // Subtle vibration feedback
      widget.onReply();
    }

    // Snap back to original position with a bouncy curve
    _controller.value = _dragExtent;
    _controller.animateTo(0, curve: Curves.easeOutBack);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 1. The Glowing Reply Icon (Revealed underneath)
          AnimatedOpacity(
            // Fades in cleanly as you reach the threshold
            opacity: (_dragExtent / _replyThreshold).clamp(0.0, 1.0),
            duration: Duration.zero,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.reply_rounded,
                color: Colors.cyanAccent,
                size: 20,
              ),
            ),
          ),

          // 2. The Message Tile (Shifts right as you drag)
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
