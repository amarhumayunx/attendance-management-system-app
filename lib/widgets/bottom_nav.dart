import 'package:flutter/material.dart';
import 'package:qrscanner/core/models/user_model.dart';
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Designation? userDesignation;
  final String? userDesignationString;
  const AppBottomNav({
    super.key, 
    required this.currentIndex, 
    required this.onTap,
    this.userDesignation,
    this.userDesignationString,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1A2E).withOpacity(0.95),
              const Color(0xFF16213E).withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final isAdmin = userDesignationString == 'admin';
            final isTeamLeader = userDesignation == Designation.teamLeader;
            final isAdminOrTeamLeader = isAdmin || isTeamLeader;
            final itemCount = isAdminOrTeamLeader ? 4 : 3;

            final totalGapWidth = (itemCount - 1) * 4.0;
            final itemWidth = (availableWidth - totalGapWidth) / itemCount;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home,
                  label: 'Home',
                  selected: currentIndex == 0,
                  onTap: () => onTap(0),
                  maxWidth: itemWidth,
                ),
                if (isAdminOrTeamLeader)
                  _NavItem(
                    icon: Icons.manage_history,
                    label: 'Manage',
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                    maxWidth: itemWidth,
                  ),
                _NavItem(
                  icon: Icons.event_note,
                  label: 'Attendance',
                  selected: currentIndex == (isAdminOrTeamLeader ? 2 : 1),
                  onTap: () => onTap(isAdminOrTeamLeader ? 2 : 1),
                  maxWidth: itemWidth,
                ),
                _NavItem(
                  icon: Icons.person,
                  label: 'Profile',
                  selected: currentIndex == (isAdminOrTeamLeader ? 3 : 2),
                  onTap: () => onTap(isAdminOrTeamLeader ? 3 : 2),
                  maxWidth: itemWidth,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? maxWidth;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.maxWidth,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: selected ? Border.all(color: Colors.white.withOpacity(0.12)) : null,
            boxShadow: selected ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.white70, size: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
