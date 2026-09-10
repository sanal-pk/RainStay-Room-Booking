import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedCoinLogo extends StatefulWidget {
  final double size;

  const AnimatedCoinLogo({super.key, this.size = 32});

  @override
  State<AnimatedCoinLogo> createState() => _AnimatedCoinLogoState();
}

class _AnimatedCoinLogoState extends State<AnimatedCoinLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _flipTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _animation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.forward();
    _startPeriodicFlip();
  }

  void _startPeriodicFlip() {
    _flipTimer?.cancel();
    _flipTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        _flip();
      }
    });
  }

  void _flip() {
    if (_controller.isAnimating) return;
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _flipTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _animation.value;
          final isFront = math.cos(angle) >= 0;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(angle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isFront
                  ? Image.asset(
                      'assets/logo.webp',
                      width: widget.size,
                      height: widget.size,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.apartment_rounded, color: AppColors.primaryTeal, size: widget.size * 0.55),
                      ),
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Image.asset(
                        'assets/logo1.webp',
                        width: widget.size,
                        height: widget.size,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.apartment_rounded, color: AppColors.primaryTeal, size: widget.size * 0.55),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
