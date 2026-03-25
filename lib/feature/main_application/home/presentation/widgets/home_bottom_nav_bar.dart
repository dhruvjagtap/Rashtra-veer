import 'package:flutter/material.dart';

/// Bottom navigation bar with 5 tabs.
enum HomeNavTab {
  home,
  activity,
  resources,
  chat,
  rank,
}

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    this.currentTab = HomeNavTab.home,
    this.onTabSelected,
  });

  final HomeNavTab currentTab;
  final ValueChanged<HomeNavTab>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentTab == HomeNavTab.home,
                onTap: () => onTabSelected?.call(HomeNavTab.home),
              ),
              _NavItem(
                icon: Icons.directions_run_rounded,
                label: 'Activity',
                isSelected: currentTab == HomeNavTab.activity,
                onTap: () => onTabSelected?.call(HomeNavTab.activity),
              ),
              _NavItem(
                icon: Icons.play_circle_outline_rounded,
                label: 'Resources',
                isSelected: currentTab == HomeNavTab.resources,
                onTap: () => onTabSelected?.call(HomeNavTab.resources),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                isSelected: currentTab == HomeNavTab.chat,
                onTap: () => onTabSelected?.call(HomeNavTab.chat),
              ),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Rank',
                isSelected: currentTab == HomeNavTab.rank,
                onTap: () => onTabSelected?.call(HomeNavTab.rank),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFF7F7BFF) : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
