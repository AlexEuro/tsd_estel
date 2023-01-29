import 'package:flutter/material.dart';

class BackgroundDrawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Path mainBG = Path();
    mainBG.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = Colors.lightBlueAccent;
    canvas.drawPath(mainBG, paint);

    Path topOrange = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..cubicTo(0, size.height * 0.45, size.width, size.height * 0.1,
          size.width, size.height * 0.45);
    paint.color = Colors.indigo;

    // canvas.drawPath(topOrange, paint);

    Path bottomOrange = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..cubicTo(0, size.height * 0.4, size.width, size.height * 0.1,
          size.width, size.height * 0.45);

    topOrange.addPath(bottomOrange, Offset(0, size.height * 0.55));

    canvas.drawPath(topOrange, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
class BackgroundSignIn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    // Blue
    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.5);
    blueWave.quadraticBezierTo(sw * 0.5, sh * 0.45, sw * 0.2, 0);
    blueWave.close();
    paint.color = Colors.blue.shade300;
    canvas.drawPath(blueWave, paint);

    // Grey
    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyWave, paint);

    // Yellow
    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.orange.shade300;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}