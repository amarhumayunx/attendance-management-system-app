import 'package:flutter/material.dart';

class AbstractBackgroundWrapper extends StatelessWidget {
  final Widget child;
  
  const AbstractBackgroundWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildAbstractBackground(context),
        child,
      ],
    );
  }

  Widget _buildAbstractBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: const Color(0xFF1A202C),
      child: Stack(
        children: [
          Positioned(
            top: -size.height * 0.1,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFB794F6).withOpacity(0.8),
                    const Color(0xFFB794F6).withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.2,
            left: -size.width * 0.3,
            child: Container(
              width: size.width * 0.7,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4FD1C7).withOpacity(0.7),
                    const Color(0xFF4FD1C7).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            bottom: -size.height * 0.15,
            right: -size.width * 0.25,
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFBD38D).withOpacity(0.6),
                    const Color(0xFFFBD38D).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.4,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2D3748).withOpacity(0.8),
                    const Color(0xFF2D3748).withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.1,
            right: size.width * 0.1,
            child: Container(
              width: size.width * 0.3,
              height: size.width * 0.3,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFED8936).withOpacity(0.5),
                    const Color(0xFFED8936).withOpacity(0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
