import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) itemTapEvent;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.itemTapEvent,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isValidIndex() {
    return widget.selectedIndex >= 0 &&
        widget.selectedIndex < 5; // 0~4까지의 인덱스만 유효
  }

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
      currentIndex: widget.selectedIndex % 5,
      selectedItemColor: isValidIndex() ? Colors.amber[800] : Colors.grey,
      unselectedItemColor: isValidIndex() ? Colors.black : Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: isValidIndex() ? widget.itemTapEvent : null,
    );
  }
}

BottomNavigationBarItem createBottomNavigationBarItem(
  IconData icon,
  String label,
) {
  return BottomNavigationBarItem(icon: Icon(icon, size: 40), label: label);
}
