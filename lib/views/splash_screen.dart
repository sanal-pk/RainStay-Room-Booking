import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'booking_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Single flip (0 -> pi), pause, then single flip (pi -> 2*pi)
    _flipAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: math.pi)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 42.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(math.pi),
        weight: 16.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: math.pi, end: 2 * math.pi)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 42.0,
      ),
    ]).animate(_flipController);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack)),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );

    _flipController.forward();

    Timer(const Duration(milliseconds: 2000), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secondaryAnim) => const BookingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // TEAL GRADIENT BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryTeal, Color(0xFF005861), Color(0xFF00383E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // CENTER BRANDING WITH REAL 3D COIN FLIP
          Center(
            child: AnimatedBuilder(
              animation: _flipController,
              builder: (context, child) {
                final angle = _flipAnimation.value;
                final isFront = math.cos(angle) >= 0;

                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 3D COIN FLIP WIDGET
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0015) // Perspective effect
                            ..rotateY(angle),
                          child: Container(
                            width: 105,
                            height: 105,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.28),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: isFront
                                  ? Image.asset(
                                      'assets/logo.webp',
                                      width: 105,
                                      height: 105,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const _FallbackIcon(),
                                    )
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: Image.asset(
                                        'assets/logo1.webp',
                                        width: 105,
                                        height: 105,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const _FallbackIcon(),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // BRAND NAME
                        const Text(
                          'RainStay',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // SUBTITLE
                        Text(
                          'Smart Hotel Management & POS System',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.82),
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // LOADING INDICATOR
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // BOTTOM METADATA
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v1.0.0 • RAINTECH SOFTWARE LIMITED',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.45),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: const Icon(Icons.apartment_rounded, color: AppColors.primaryTeal, size: 48),
    );
  }
}
