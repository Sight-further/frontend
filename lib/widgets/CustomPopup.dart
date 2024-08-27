import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final String schoolName;
  final VoidCallback onClose;

  const CustomPopup({
    Key? key, 
    required this.schoolName, 
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // overflow: visible 처럼 동작하도록 설정
      children: [
        // 팝업 배경 (흰색 말풍선)
        Positioned(
          top: 20, // 삼각형 높이만큼 아래로 이동
          left: 0,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 20, top: 15, bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  schoolName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
        ),
        // 말풍선 아래 삼각형
        Positioned(
          top: 0,
          left: 10,  // 팝업 위치에 따라 조절 가능
          child: CustomPaint(
            size: const Size(20, 20),
            painter: _TrianglePainter(
              strokeColor: Colors.white,
              strokeWidth: 3,
              paintingStyle: PaintingStyle.fill,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  _TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 2.0,
    this.paintingStyle = PaintingStyle.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    Path path = Path();
    path.moveTo(size.width / 2, 0); // 시작점 (상단 중앙)
    path.lineTo(0, size.height);    // 왼쪽 아래
    path.lineTo(size.width, size.height);  // 오른쪽 아래
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}