import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../controllers/booking_controller.dart';
import 'animated_coin_logo.dart';

class TealPOSNavBar extends StatefulWidget {
  const TealPOSNavBar({super.key});

  @override
  State<TealPOSNavBar> createState() => _TealPOSNavBarState();
}

class _TealPOSNavBarState extends State<TealPOSNavBar> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _dashboardKey = GlobalKey();
  final GlobalKey _checkinKey = GlobalKey();
  final GlobalKey _checkoutKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTab(String tab) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalKey? key;
      if (tab == 'dashboard') key = _dashboardKey;
      if (tab == 'checkin') key = _checkinKey;
      if (tab == 'checkout') key = _checkoutKey;

      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryTeal, AppColors.primaryTealLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          if (isWide) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT: BRAND LOGO + TABS
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AnimatedCoinLogo(size: 32),
                    const SizedBox(width: 10),
                    const Text(
                      'RainStay',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NavCapsule(
                          title: 'Dashboard',
                          icon: Icons.dashboard_rounded,
                          isSelected: controller.currentTab == 'dashboard',
                          onTap: () => controller.switchTab('dashboard'),
                        ),
                        const SizedBox(width: 8),
                        NavCapsule(
                          title: 'Check-in',
                          icon: Icons.login_rounded,
                          badge: '${controller.availableRoomsCount}',
                          isSelected: controller.currentTab == 'checkin',
                          onTap: () => controller.switchTab('checkin'),
                        ),
                        const SizedBox(width: 8),
                        NavCapsule(
                          title: 'Check-out',
                          icon: Icons.logout_rounded,
                          badge: '${controller.occupiedRoomsCount}',
                          isSelected: controller.currentTab == 'checkout',
                          onTap: () => controller.switchTab('checkout'),
                        ),
                      ],
                    ),
                  ],
                ),

                // RIGHT: DATE / TIME CHIP + AVATAR
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('EEE, dd MMM • hh:mm a').format(DateTime.now()),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ],
            );
          }

          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // BRAND LOGO
                const AnimatedCoinLogo(size: 32),
                const SizedBox(width: 8),
                const Text(
                  'RainStay',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 16),
                NavCapsule(
                  key: _dashboardKey,
                  title: 'Dashboard',
                  icon: Icons.dashboard_rounded,
                  isSelected: controller.currentTab == 'dashboard',
                  onTap: () {
                    controller.switchTab('dashboard');
                    _scrollToTab('dashboard');
                  },
                ),
                const SizedBox(width: 6),
                NavCapsule(
                  key: _checkinKey,
                  title: 'Check-in',
                  icon: Icons.login_rounded,
                  badge: '${controller.availableRoomsCount}',
                  isSelected: controller.currentTab == 'checkin',
                  onTap: () {
                    controller.switchTab('checkin');
                    _scrollToTab('checkin');
                  },
                ),
                const SizedBox(width: 6),
                NavCapsule(
                  key: _checkoutKey,
                  title: 'Check-out',
                  icon: Icons.logout_rounded,
                  badge: '${controller.occupiedRoomsCount}',
                  isSelected: controller.currentTab == 'checkout',
                  onTap: () {
                    controller.switchTab('checkout');
                    _scrollToTab('checkout');
                  },
                ),
                const SizedBox(width: 12),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NavCapsule extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const NavCapsule({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppColors.primaryTeal : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primaryTeal : Colors.white,
              ),
            ),
            if (badge != null && badge != '0') ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryTeal : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
