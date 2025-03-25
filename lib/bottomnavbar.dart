import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) itemTapEvent;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.itemTapEvent,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //네이게이션 바 아이템
      items: <BottomNavigationBarItem>[
        createBottomNavigationBarItem(Icons.home, "홈"),
        createBottomNavigationBarItem(Icons.description, "통계"),
        createBottomNavigationBarItem(Icons.book, "일기"),
        createBottomNavigationBarItem(Icons.remove_red_eye, "들춰보기"),
        createBottomNavigationBarItem(Icons.flag, "도전과제"),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      onTap: itemTapEvent,
    );
  }
}

BottomNavigationBarItem createBottomNavigationBarItem(
  IconData icon,
  String label,
) {
  return BottomNavigationBarItem(icon: Icon(icon, size: 40), label: label);
}
