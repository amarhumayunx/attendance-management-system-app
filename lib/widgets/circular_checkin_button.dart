import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qrscanner/core/constants/app_typography.dart';

import '../res/assets_res.dart';

class CircularCheckInButton extends StatefulWidget {
  final bool canTap;
  final String label;
  final VoidCallback onTap;
  final String? currentTime;
  final String? currentLocation;

  const CircularCheckInButton({
    super.key,
    required this.canTap,
    required this.label,
    required this.onTap,
    this.currentTime,
    this.currentLocation,
  });

  @override
  State<CircularCheckInButton> createState() => _CircularCheckInButtonState();
}

class _CircularCheckInButtonState extends State<CircularCheckInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
    _updateTime();
    _startTimeUpdater();
  }

  void _startTimeUpdater() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _updateTime();
        _startTimeUpdater();
      }
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Time display above button
        _buildTimeDisplay(),
        const SizedBox(height: 20),
        
        // Main circular button
        _buildCircularButton(),
        const SizedBox(height: 20),
        
        // Location display below button
        _buildLocationDisplay(),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Column(
      children: [
        Text(
          _currentTime,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
          style: AppTypography.kMedium14,
        ),
      ],
    );
  }

  Widget _buildCircularButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.canTap ? widget.onTap : null,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 20 * _glowAnimation.value,
                    spreadRadius: 5 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetsRes.CHECKIN,
                      width: 34,
                      height: 34,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.label,
                      style: AppTypography.kSemiBold16Black,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            widget.currentLocation ?? 'Location unavailable',
            style: AppTypography.kMedium14,
          ),
        ],
      ),
    );
  }
}
