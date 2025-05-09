// lib/widgets/room_painter.dart

import 'package:flutter/material.dart';

class RoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2;

    // Vanishing point somewhere near the top center
    final vp = Offset(size.width * 0.5, size.height * 0.1);

    // Four “floor” corners
    final bl = Offset(0, size.height);               // bottom-left
    final br = Offset(size.width, size.height);      // bottom-right
    final tl = Offset(0, size.height * 0.4);         // top-left wall corner
    final tr = Offset(size.width, size.height * 0.4); // top-right wall corner

    // Draw floor edges (vanishing point -> bottom corners)
    canvas.drawLine(vp, bl, paint);
    canvas.drawLine(vp, br, paint);

    // Draw side walls (top corners -> bottom corners)
    canvas.drawLine(tl, bl, paint);
    canvas.drawLine(tr, br, paint);

    // Draw ceiling edges (vanishing point -> wall top corners)
    canvas.drawLine(vp, tl, paint);
    canvas.drawLine(vp, tr, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// A helper widget
class RoomView extends StatelessWidget {
  final Widget child;
  const RoomView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RoomPainter(),
      child: child,
    );
  }
}
