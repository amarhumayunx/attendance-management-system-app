import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/res/assets_res.dart';

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

  List<NavItemData> _getNavItems() {
    final isAdmin = userDesignation == Designation.admin;
    final isTeamLeader = userDesignation == Designation.teamLeader;
    final isAdminOrTeamLeader = isAdmin || isTeamLeader;

    List<NavItemData> items = [
      NavItemData(
        svgPath: AssetsRes.HOME,
        label: 'Home',
        index: 0,
      ),
    ];

    if (isAdminOrTeamLeader) {
      items.add(NavItemData(
        svgPath: AssetsRes.MANAGEMENT,
        label: 'Manage',
        index: 1,
      ));
    }

    items.addAll([
      NavItemData(
        svgPath: AssetsRes.ATTENDANCE,
        label: 'Attendance',
        index: isAdminOrTeamLeader ? 2 : 1,
      ),
      NavItemData(
        svgPath: AssetsRes.PROFILE,
        label: 'Profile',
        index: isAdminOrTeamLeader ? 3 : 2,
      ),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _getNavItems();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: navItems.length > 3 ? 72 : 68, // Slightly taller for admin mode
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // semi-transparent for glass look
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: navItems.map((item) {
                  return _NavItem(
                    svgPath: item.svgPath,
                    label: item.label,
                    selected: currentIndex == item.index,
                    onTap: () => onTap(item.index),
                    isAdminMode: navItems.length > 3, // More than 3 items means admin mode
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItemData {
  final String svgPath;
  final String label;
  final int index;

  NavItemData({
    required this.svgPath,
    required this.label,
    required this.index,
  });
}

class _NavItem extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isAdminMode;

  const _NavItem({
    required this.svgPath,
    required this.label,
    required this.selected,
    required this.onTap,
    this.isAdminMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? (isAdminMode ? 8 : 12) : 6,
              vertical: 8,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: selected
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with smooth transition
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: SvgPicture.asset(
                    svgPath,
                    width: isAdminMode ? 20 : 22,
                    height: isAdminMode ? 20 : 22,
                    colorFilter: ColorFilter.mode(
                      selected ? Colors.black : Colors.white,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (context) => Icon(
                      _getFallbackIcon(label),
                      size: isAdminMode ? 20 : 22,
                      color: selected ? Colors.black : Colors.black,
                    ),
                  ),
                ),

                // Animated text with improved spacing
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment.centerLeft,
                  child: selected
                      ? Padding(
                    padding: EdgeInsets.only(left: isAdminMode ? 4.0 : 6.0),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: selected ? 1.0 : 0.0,
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: isAdminMode ? 9 : 11,
                          letterSpacing: 0.3,
                          height: 1.2,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFallbackIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'manage':
        return Icons.manage_accounts_outlined;
      case 'attendance':
        return Icons.access_time_outlined;
      case 'profile':
        return Icons.person_outline;
      default:
        return Icons.help_outline;
    }
  }
}