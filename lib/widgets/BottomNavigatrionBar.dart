import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar(
    {super.key, required this.currentIndex, required this.onTap}
  );

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF3F4F6),
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: '지도',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: '지도',
        ),
      ],
      selectedItemColor: const Color(0xff03AA71),
    );
  }
}