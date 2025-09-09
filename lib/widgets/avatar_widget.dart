import 'package:flutter/material.dart';
class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? firstName;
  final String? lastName;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final Widget? fallbackIcon;
  final BoxDecoration? decoration;
  final List<BoxShadow>? boxShadow;
  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.firstName,
    this.lastName,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fallbackIcon,
    this.decoration,
    this.boxShadow,
  });
  @override
  Widget build(BuildContext context) {
    final hasValidImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final initials = _getInitials();
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? const Color(0xFF4ECDC4),
      backgroundImage: hasValidImage ? NetworkImage(imageUrl!) : null,
      child: hasValidImage
          ? null
          : (fallbackIcon ?? Text(
              initials,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? (radius * 0.6),
              ),
            )),
    );

    if (decoration != null || boxShadow != null) {
      avatar = Container(
        decoration: decoration?.copyWith(
          boxShadow: boxShadow,
        ) ?? BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
        ),
        child: avatar,
      );
    }
    return avatar;
  }
  String _getInitials() {
    final first = (firstName ?? '').trim();
    final last = (lastName ?? '').trim();
    if (first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    } else if (first.isNotEmpty) {
      return first[0].toUpperCase();
    } else if (last.isNotEmpty) {
      return last[0].toUpperCase();
    } else {
      return 'U';
    }
  }
}
