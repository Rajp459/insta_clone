import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.5
          )
        )
      ),
      child: BottomNavigationBar(
        elevation: 8,
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 28),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 1 ? Icons.search : Icons.search_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 2 ? Icons.add_box : Icons.add_box_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 3 ? Icons.play_circle : Icons.play_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 4 ? Icons.person : Icons.person_outline, size: 20),
            label: '',
          ),
        ],
      ),
    );
  }
}
