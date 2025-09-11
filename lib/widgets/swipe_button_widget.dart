import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwipeButton extends StatefulWidget {
  final bool canSwipe;
  final String label;
  final VoidCallback onSwipeComplete;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? height;

  const SwipeButton({
    super.key,
    required this.canSwipe,
    required this.label,
    required this.onSwipeComplete,
    this.primaryColor,
    this.backgroundColor,
    this.height,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton>
    with SingleTickerProviderStateMixin {
  double _swipeProgress = 0.0;
  late AnimationController _animationController;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _primaryColor => widget.primaryColor ?? Colors.grey;
  Color get _backgroundColor => widget.backgroundColor ?? const Color(0xFF1F2937).withOpacity(0.2);
  double get _height => widget.height ?? 70.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        const knobSize = 56.0;
        const knobMargin = 8.0;
        final effectiveWidth = totalWidth - (knobSize + knobMargin * 2);
        final dx = (_swipeProgress.clamp(0.0, 1.0)) * effectiveWidth;
        
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return GestureDetector(
              onHorizontalDragUpdate: widget.canSwipe && !_isCompleting
                  ? (details) {
                      setState(() {
                        _swipeProgress = (_swipeProgress + details.delta.dx / effectiveWidth)
                            .clamp(0.0, 1.0);
                      });
                    }
                  : null,
              onHorizontalDragEnd: widget.canSwipe && !_isCompleting
                  ? (_) async {
                      if (_swipeProgress > 0.8) {
                        setState(() {
                          _isCompleting = true;
                          _swipeProgress = 1.0;
                        });
                        
                        await Future.delayed(const Duration(milliseconds: 300));
                        widget.onSwipeComplete();
                        
                        if (mounted) {
                          setState(() {
                            _swipeProgress = 0.0;
                            _isCompleting = false;
                          });
                        }
                      } else {
                        setState(() {
                          _swipeProgress = 0.0;
                        });
                      }
                    }
                  : null,
              child: Container(
                height: _height,
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(_height / 2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Wave progress fill
                    ClipRRect(
                      borderRadius: BorderRadius.circular(_height / 2),
                      child: CustomPaint(
                        size: Size(totalWidth, _height),
                        painter: WaveProgressPainter(
                          progress: _swipeProgress,
                          color: _primaryColor,
                          height: _height,
                          width: totalWidth,
                          animationValue: _animationController.value,
                        ),
                      ),
                    ),
                    
                    // Text label
                    Center(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _swipeProgress > 0.5 ? 0.4 : 1.0,
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    
                    // Swipe knob
                    AnimatedPositioned(
                      duration: _isCompleting 
                          ? const Duration(milliseconds: 300)
                          : Duration.zero,
                      curve: Curves.elasticOut,
                      left: knobMargin + dx,
                      child: Container(
                        width: knobSize,
                        height: knobSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _swipeProgress > 0.8
                                ? Icons.check
                                : Icons.keyboard_double_arrow_right,
                            key: ValueKey(_swipeProgress > 0.8),
                            color: _swipeProgress > 0.8 
                                ? _primaryColor 
                                : const Color(0xFF6B7280),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double height;
  final double width;
  final double animationValue;
  
  WaveProgressPainter({
    required this.progress,
    required this.color,
    required this.height,
    required this.width,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path = Path();
    final progressWidth = progress * width;
    final radius = height / 2;
    
    // Wave parameters
    final waveHeight = 8.0;
    final waveLength = 40.0;
    final waveSpeed = animationValue * waveLength * 4;
    
    // Create rounded rectangle base first
    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, progressWidth, height),
      Radius.circular(radius),
    );
    
    if (progressWidth <= radius * 2) {
      // For small progress, just draw rounded shape without wave
      path.addRRect(roundedRect);
    } else {
      // Create base rounded rectangle path
      path.addRRect(roundedRect);
      
      // Only add wave effect to the right edge, keeping it inside bounds
      if (progressWidth > radius * 2) {
        final wavePath = Path();
        
        // Start wave from where rounded part ends
        final waveStartX = progressWidth - radius;
        final waveEndX = progressWidth;
        
        List<Offset> wavePoints = [];
        
        // Generate wave points only for the curved right section
        for (double y = radius * 0.2; y <= height - radius * 0.2; y += 1) {
          // Calculate base position on the rounded edge
          final normalizedY = (y - radius) / (height - 2 * radius);
          
          // Create wave effect
          double waveOffset = (y / height * 8 + waveSpeed) % (2 * math.pi);
          double wave = waveHeight * math.sin(waveOffset);
          
          // Apply wave intensity (stronger in middle)
          double intensity = math.sin(normalizedY * math.pi);
          wave *= intensity * 1.2; // Increase intensity for more visible wave
          
          // Keep wave inside the rounded bounds
          double maxWave = radius * 0.25; // Increase wave limit for more visibility
          wave = wave.clamp(-maxWave, maxWave);
          
          // Position wave on right edge, but inside the rounded container
          double baseX = waveEndX - radius * 0.2; // Move wave closer to edge for more visibility
          wavePoints.add(Offset(baseX + wave, y));
        }

        if (wavePoints.isNotEmpty) {
          final waveRegion = Path();

          waveRegion.moveTo(progressWidth - radius * 0.5, radius * 0.3);

          waveRegion.lineTo(progressWidth - radius * 0.5, height - radius * 0.3);
          waveRegion.close();

          path = Path.combine(PathOperation.union, path, waveRegion);
        }
      }
    }

    final clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      Radius.circular(radius),
    ));

    path = Path.combine(PathOperation.intersect, path, clipPath);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || 
      oldDelegate.animationValue != animationValue;
}