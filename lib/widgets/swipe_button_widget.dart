import 'package:flutter/material.dart';
class SwipeButton extends StatefulWidget {
  final bool canSwipe;
  final String label;
  final VoidCallback onSwipeComplete;
  const SwipeButton({
    super.key,
    required this.canSwipe,
    required this.label,
    required this.onSwipeComplete,
  });
  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}
class _SwipeButtonState extends State<SwipeButton> {
  double _swipeProgress = 0.0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        const knobSize = 60.0;
        const knobMargin = 6.0;
        final trackHeight = 70.0;
        final effectiveWidth = totalWidth - (knobSize + knobMargin * 2);
        final dx = (_swipeProgress.clamp(0.0, 1.0)) * effectiveWidth;
        return GestureDetector(
          onHorizontalDragUpdate: widget.canSwipe
              ? (details) {
                  setState(() {
                    _swipeProgress = (_swipeProgress + details.delta.dx / effectiveWidth).clamp(0.0, 1.0);
                  });
                }
              : null,
          onHorizontalDragEnd: widget.canSwipe
              ? (_) async {
                  if (_swipeProgress > 0.6) {
                    setState(() { _swipeProgress = 1.0; });
                    widget.onSwipeComplete();
                  }
                  if (mounted) {
                    setState(() { _swipeProgress = 0.0; });
                  }
                }
              : null,
          child: Container(
            height: trackHeight,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: widget.canSwipe ? Colors.white : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  left: knobMargin + dx,
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: BoxDecoration(
                      gradient: widget.canSwipe 
                          ? const LinearGradient(
                              colors: [Colors.white, Colors.white],
                            )
                          : LinearGradient(
                              colors: [Colors.grey.shade400, Colors.grey.shade500],
                            ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.keyboard_double_arrow_right,
                      color: widget.canSwipe ? const Color(0xFF1A1A2E) : Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
