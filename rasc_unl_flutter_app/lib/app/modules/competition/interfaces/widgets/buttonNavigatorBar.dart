
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class ButtonNavigatorBar extends StatelessWidget {
  final List<IconData> iconsList;
  final ValueChanged<int> onTap;
  final int initialIndex;

  const ButtonNavigatorBar({
    super.key,
    required this.iconsList,
    required this.onTap,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD50000).withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color(0xFF2A2A2A),
        index: initialIndex,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOutCubic,
        buttonBackgroundColor: Color(0xFFD50000),
        height: 65,
        items: iconsList
            .map((icon) => Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ))
            .toList(),
        onTap: onTap,
      ),
    );
  }
}
