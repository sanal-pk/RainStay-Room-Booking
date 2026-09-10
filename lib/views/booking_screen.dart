import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/booking_controller.dart';
import '../models/room.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  int _getTabIndex(String tab) {
    switch (tab) {
      case 'dashboard':
        return 0;
      case 'checkin':
        return 1;
      case 'checkout':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            // MAIN VIEW CONTAINER
            Column(
              children: [
                const _TealPOSNavBar(),
                Expanded(
                  child: IndexedStack(
                    index: _getTabIndex(controller.currentTab),
                    children: const [
                      _DashboardView(),
                      _CheckInView(),
                      _CheckOutView(),
                    ],
                  ),
                ),
              ],
            ),

            // DECORATIVE BOTTOM CITYSCAPE & WAVES (Anchored globally at very bottom of screen)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 75,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _IllustratedCityscapePainter(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 🌊 1. TEAL TOP NAVBAR
// ============================================================================
class _TealPOSNavBar extends StatelessWidget {
  const _TealPOSNavBar();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007A87), Color(0xFF008997)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.apartment_rounded, color: Color(0xFF007A87), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'RainStay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(width: 36),
          Row(
            children: [
              _NavCapsule(
                title: 'Dashboard',
                icon: Icons.dashboard_rounded,
                isSelected: controller.currentTab == 'dashboard',
                onTap: () => controller.switchTab('dashboard'),
              ),
              const SizedBox(width: 10),
              _NavCapsule(
                title: 'Check-in',
                icon: Icons.login_rounded,
                badge: '${controller.availableRoomsCount}',
                isSelected: controller.currentTab == 'checkin',
                onTap: () => controller.switchTab('checkin'),
              ),
              const SizedBox(width: 10),
              _NavCapsule(
                title: 'Check-out',
                icon: Icons.logout_rounded,
                badge: '${controller.occupiedRoomsCount}',
                isSelected: controller.currentTab == 'checkout',
                onTap: () => controller.switchTab('checkout'),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEE, dd MMM • hh:mm a').format(DateTime.now()),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

class _NavCapsule extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _NavCapsule({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? const Color(0xFF007A87) : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF007A87) : Colors.white,
              ),
            ),
            if (badge != null && badge != '0') ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF007A87) : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 10,
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

// ============================================================================
// 📊 2. MAIN DASHBOARD VIEW
// ============================================================================
class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4 STAT CARDS
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.hotel_rounded,
                  iconBg: const Color(0xFF86EFAC),
                  iconColor: const Color(0xFF166534),
                  cardBg: const Color(0xFFF0FDF4),
                  cardBorder: const Color(0xFFBBF7D0),
                  title: 'Occupancy',
                  value: '${controller.occupancyRate}%',
                  subtitle: '${controller.occupiedRoomsCount} of ${controller.totalRooms} rooms',
                  arrowIcon: Icons.arrow_upward_rounded,
                  arrowColor: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon: Icons.event_available_rounded,
                  iconBg: const Color(0xFFBAE6FD),
                  iconColor: const Color(0xFF0369A1),
                  cardBg: const Color(0xFFF0F9FF),
                  cardBorder: const Color(0xFFBAE6FD),
                  title: 'Available',
                  value: '${controller.availableRoomsCount}',
                  subtitle: 'Ready for check-in',
                  arrowIcon: Icons.arrow_forward_rounded,
                  arrowColor: const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon: Icons.person_outline_rounded,
                  iconBg: const Color(0xFFFED7AA),
                  iconColor: const Color(0xFF9A3412),
                  cardBg: const Color(0xFFFFFBEB),
                  cardBorder: const Color(0xFFFDE68A),
                  title: 'Occupied',
                  value: '${controller.occupiedRoomsCount}',
                  subtitle: 'Active guest stays',
                  arrowIcon: Icons.arrow_forward_rounded,
                  arrowColor: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon: Icons.cleaning_services_rounded,
                  iconBg: const Color(0xFFFECDD3),
                  iconColor: const Color(0xFF9F1239),
                  cardBg: const Color(0xFFFFF1F2),
                  cardBorder: const Color(0xFFFECDD3),
                  title: 'Housekeeping',
                  value: '${controller.dirtyRoomsCount}',
                  subtitle: 'Needs cleaning',
                  arrowIcon: Icons.arrow_forward_rounded,
                  arrowColor: const Color(0xFFE11D48),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ACTIVE GUEST STAYS CARD
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.people_alt_rounded, color: Color(0xFF007A87), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Active Guest Stays',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        Text(
                          '${controller.occupiedRoomsCount} occupied',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (controller.occupiedRoomsList.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text('No active guest stays right now.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    ),
                  )
                else
                  ...controller.occupiedRoomsList.map((room) => _ActiveStayRow(room: room, controller: controller)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // INTERACTIVE ROOM INVENTORY
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.hotel_rounded, color: Color(0xFF007A87), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Interactive Room Inventory',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _LegendDot(color: const Color(0xFF10B981), label: 'Available'),
                        const SizedBox(width: 14),
                        _LegendDot(color: const Color(0xFF3B82F6), label: 'Occupied'),
                        const SizedBox(width: 14),
                        _LegendDot(color: const Color(0xFFEF4444), label: 'Dirty'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: controller.rooms.map((room) => _RoomCardTile(room: room, controller: controller)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- DASHBOARD WIDGET COMPONENTS ----------------
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color cardBg;
  final Color cardBorder;
  final String title;
  final String value;
  final String subtitle;
  final IconData arrowIcon;
  final Color arrowColor;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.cardBg,
    required this.cardBorder,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.arrowIcon,
    required this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(arrowIcon, color: arrowColor, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF334155)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveStayRow extends StatelessWidget {
  final Room room;
  final BookingController controller;

  const _ActiveStayRow({required this.room, required this.controller});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF007A87),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              room.roomCode,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.currentGuest ?? 'Guest',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
                Text(
                  room.roomType,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Text(
            room.checkInDate != null && room.checkOutDate != null
                ? '${dateFormat.format(room.checkInDate!)}  ➔  ${dateFormat.format(room.checkOutDate!)}'
                : 'Active Stay',
            style: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 24),
          Text(
            '${currencyFormat.format(room.pricePerNight)}/nt',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(width: 20),
          InkWell(
            onTap: () => controller.switchTab('checkout', room: room),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF99F6E4)),
              ),
              child: const Text(
                'Checked Out',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF007A87)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCardTile extends StatelessWidget {
  final Room room;
  final BookingController controller;

  const _RoomCardTile({required this.room, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isOccupied = room.status == RoomStatus.occupied;
    final isDirty = room.status == RoomStatus.dirty;

    final dotColor = isOccupied
        ? const Color(0xFF3B82F6)
        : (isDirty ? const Color(0xFFEF4444) : const Color(0xFF10B981));

    final bottomBorderColor = isOccupied
        ? const Color(0xFF3B82F6)
        : (isDirty ? const Color(0xFFEF4444) : const Color(0xFF10B981));

    final iconBg = isOccupied
        ? const Color(0xFFEFF6FF)
        : (isDirty ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4));

    final iconColor = isOccupied
        ? const Color(0xFF2563EB)
        : (isDirty ? const Color(0xFFDC2626) : const Color(0xFF16A34A));

    final IconData icon = isOccupied
        ? Icons.person_rounded
        : (isDirty ? Icons.cleaning_services_rounded : Icons.hotel_rounded);

    final pillBg = isOccupied
        ? const Color(0xFFEFF6FF)
        : (isDirty ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4));

    final pillTextColor = isOccupied
        ? const Color(0xFF2563EB)
        : (isDirty ? const Color(0xFFDC2626) : const Color(0xFF16A34A));

    final pillText = isOccupied
        ? (room.currentGuest ?? 'Occupied')
        : (isDirty ? 'Dirty (Clean)' : 'Available (Book)');

    return InkWell(
      onTap: () {
        if (isOccupied) {
          controller.switchTab('checkout', room: room);
        } else if (isDirty) {
          controller.markRoomClean(room);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✨ Room ${room.roomCode} marked as clean & ready!')),
          );
        } else {
          controller.switchTab('checkin', room: room);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                        child: Icon(icon, size: 15, color: iconColor),
                      ),
                      Text(
                        room.roomCode,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.roomType,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: pillBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      pillText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: pillTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 3,
              color: bottomBorderColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ============================================================================
// 🎨 ACCURATE ILLUSTRATED CITYSCAPE & WAVES CANVAS PAINTER
// ============================================================================
class _IllustratedCityscapePainter extends CustomPainter {
  const _IllustratedCityscapePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. BACK SOFT WAVE (Light turquoise)
    final backWavePaint = Paint()
      ..color = const Color(0xFFCCFBF1).withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    final backWave = Path()
      ..moveTo(0, h * 0.55)
      ..quadraticBezierTo(w * 0.25, h * 0.35, w * 0.5, h * 0.55)
      ..quadraticBezierTo(w * 0.75, h * 0.75, w, h * 0.45)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(backWave, backWavePaint);

    // 2. SUN ON RIGHT
    final sunCenter = Offset(w * 0.93, h * 0.28);
    final sunPaint = Paint()
      ..color = const Color(0xFFFDE047).withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, 13, sunPaint);

    // 3. CITY BUILDINGS ON RIGHT
    final bldg1Paint = Paint()..color = const Color(0xFF007A87);
    final bldg2Paint = Paint()..color = const Color(0xFF38BDF8);
    final bldg3Paint = Paint()..color = const Color(0xFF2DD4BF);
    final windowPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);

    // Main center tall building
    final bldg1Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.895, h * 0.35, 34, h * 0.65),
      const Radius.circular(2),
    );
    canvas.drawRRect(bldg1Rect, bldg1Paint);

    // Windows for main building
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 2; c++) {
        canvas.drawRect(
          Rect.fromLTWH(w * 0.895 + 6 + (c * 13), h * 0.35 + 8 + (r * 11), 7, 6),
          windowPaint,
        );
      }
    }

    // Side building left
    final bldg2Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.85, h * 0.52, 26, h * 0.48),
      const Radius.circular(2),
    );
    canvas.drawRRect(bldg2Rect, bldg2Paint);

    // Side building right
    final bldg3Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.938, h * 0.48, 28, h * 0.52),
      const Radius.circular(2),
    );
    canvas.drawRRect(bldg3Rect, bldg3Paint);

    // Trees
    final treePaint1 = Paint()..color = const Color(0xFF22C55E);
    final treePaint2 = Paint()..color = const Color(0xFF16A34A);
    canvas.drawCircle(Offset(w * 0.84, h * 0.85), 11, treePaint1);
    canvas.drawCircle(Offset(w * 0.978, h * 0.85), 10, treePaint2);

    // 4. FOREGROUND FLOWING WAVES
    final foreWavePaint = Paint()
      ..color = const Color(0xFF0D9488).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final foreWave = Path()
      ..moveTo(0, h * 0.75)
      ..quadraticBezierTo(w * 0.35, h * 0.92, w * 0.65, h * 0.72)
      ..quadraticBezierTo(w * 0.82, h * 0.6, w, h * 0.78)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(foreWave, foreWavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// 🏨 3. CHECK-IN VIEW
// ============================================================================
class _CheckInView extends StatelessWidget {
  const _CheckInView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          child: isDesktop
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _SectionContainer(step: '1', title: 'Dates & Room Selection', child: _CheckInDatesContent())),
                    SizedBox(width: 16),
                    Expanded(flex: 4, child: _SectionContainer(step: '2', title: 'Guest & Rate Details', child: _CheckInDetailsContent())),
                    SizedBox(width: 16),
                    Expanded(flex: 3, child: _SectionContainer(step: '3', title: 'Summary & Payment', child: _CheckInSummaryContent())),
                  ],
                )
              : const Column(
                  children: [
                    _SectionContainer(step: '1', title: 'Dates & Room Selection', child: _CheckInDatesContent()),
                    SizedBox(height: 16),
                    _SectionContainer(step: '2', title: 'Guest & Rate Details', child: _CheckInDetailsContent()),
                    SizedBox(height: 16),
                    _SectionContainer(step: '3', title: 'Summary & Payment', child: _CheckInSummaryContent()),
                  ],
                ),
        );
      },
    );
  }
}

class _CheckInDatesContent extends StatelessWidget {
  const _CheckInDatesContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final dateFormat = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('STAY DATES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7)),
              lastDate: now.add(const Duration(days: 365)),
              initialDateRange: controller.dateRange,
              helpText: 'Select Stay Period',
            );
            if (picked != null) {
              controller.setDateRange(picked);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.date_range_rounded, size: 15, color: Color(0xFF007A87)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.checkInDate != null && controller.checkOutDate != null
                        ? '${dateFormat.format(controller.checkInDate!)} → ${dateFormat.format(controller.checkOutDate!)}'
                        : 'Select Check-in & Check-out Dates',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                  ),
                ),
                if (controller.nights > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF007A87), borderRadius: BorderRadius.circular(4)),
                    child: Text('${controller.nights} nt', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),

        if (controller.validationError != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFFCA5A5))),
            child: Text(controller.validationError!, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],

        const SizedBox(height: 14),
        const Text('AVAILABLE INVENTORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
        const SizedBox(height: 6),

        Column(
          children: controller.rooms.where((r) => r.status != RoomStatus.occupied).map((room) {
            final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: InkWell(
                onTap: () => controller.selectRoom(room),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE6F7F5) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? const Color(0xFF007A87) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF007A87) : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          room.roomCode,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(room.roomType, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        currencyFormat.format(room.pricePerNight),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_off,
                        color: isSelected ? const Color(0xFF007A87) : const Color(0xFFCBD5E1),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CheckInDetailsContent extends StatelessWidget {
  const _CheckInDetailsContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final room = controller.selectedRoom;

    if (room == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(36.0),
          child: Text('Select a room in Step 1 to review details', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF007A87),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(room.roomCode, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(room.roomType, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0F172A))),
            ),
          ],
        ),
        const SizedBox(height: 12),

        const Text('Guest Name', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        TextFormField(
          initialValue: controller.guestName,
          onChanged: controller.setGuestName,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(child: _InfoFieldItem(label: 'Price / Night', value: currencyFormat.format(room.pricePerNight))),
            const SizedBox(width: 8),
            Expanded(child: _InfoFieldItem(label: 'Max Guests', value: '${room.maxGuests} Guests')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _InfoFieldItem(label: 'Duration', value: '${controller.nights} night(s)')),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoFieldItem(
                label: 'Check-out Date',
                value: controller.checkOutDate != null ? DateFormat('dd MMM').format(controller.checkOutDate!) : '—',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckInSummaryContent extends StatelessWidget {
  const _CheckInSummaryContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
            Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Color(0xFF0F172A))),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 10),
        _LineItemRow(title: 'Room Rent', value: currencyFormat.format(controller.roomCharge)),
        const SizedBox(height: 4),
        const _LineItemRow(title: 'Taxes / Fees (0%)', value: '₹0.00'),
        const SizedBox(height: 14),

        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: controller.canConfirmBooking
                ? () {
                    controller.confirmCheckIn();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Check-in completed successfully!'),
                        backgroundColor: Color(0xFF007A87),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007A87),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              elevation: 0,
            ),
            child: const Text('Complete Check-in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 🚪 4. CHECK-OUT VIEW
// ============================================================================
class _CheckOutView extends StatelessWidget {
  const _CheckOutView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          child: isDesktop
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _SectionContainer(step: '1', title: 'Departing Guest Selection', child: _CheckOutSelectContent())),
                    SizedBox(width: 16),
                    Expanded(flex: 4, child: _SectionContainer(step: '2', title: 'Itemized Invoice Review', child: _CheckOutBillContent())),
                    SizedBox(width: 16),
                    Expanded(flex: 3, child: _SectionContainer(step: '3', title: 'Settlement & Payment', child: _CheckOutPaymentContent())),
                  ],
                )
              : const Column(
                  children: [
                    _SectionContainer(step: '1', title: 'Departing Guest Selection', child: _CheckOutSelectContent()),
                    SizedBox(height: 16),
                    _SectionContainer(step: '2', title: 'Itemized Invoice Review', child: _CheckOutBillContent()),
                    SizedBox(height: 16),
                    _SectionContainer(step: '3', title: 'Settlement & Payment', child: _CheckOutPaymentContent()),
                  ],
                ),
        );
      },
    );
  }
}

class _CheckOutSelectContent extends StatelessWidget {
  const _CheckOutSelectContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final occupiedRooms = controller.occupiedRoomsList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('OCCUPIED ROOMS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        if (occupiedRooms.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text('No occupied rooms to check out.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ),
          )
        else
          Column(
            children: occupiedRooms.map((room) {
              final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                  onTap: () => controller.selectRoomForCheckout(room),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE6F7F5) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? const Color(0xFF007A87) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF007A87),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(room.roomCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(room.currentGuest ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(room.roomType, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.radio_button_off,
                          color: isSelected ? const Color(0xFF007A87) : const Color(0xFFCBD5E1),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _CheckOutBillContent extends StatelessWidget {
  const _CheckOutBillContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final room = controller.selectedRoom;

    if (room == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(36.0),
          child: Text('Select an occupied room from Step 1', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '[Room ${room.roomCode}] — ${room.currentGuest ?? 'Guest'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
        ),
        Text(
          '${controller.nights} night(s) × ${currencyFormat.format(room.pricePerNight)}',
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),

        const Text('Incidentals & Extra Charges', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
        const SizedBox(height: 6),

        if (room.extraCharges.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Text('No extra charges recorded.', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: room.extraCharges.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                      Text(currencyFormat.format(item.amount), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Room ${room.roomCode} Total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF0F172A))),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckOutPaymentContent extends StatelessWidget {
  const _CheckOutPaymentContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
            Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Color(0xFF0F172A))),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 10),

        const Text('Payment Method', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('UPI / Card / Cash', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_drop_down, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 14),

        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: controller.selectedRoom != null
                ? () {
                    final roomCode = controller.selectedRoom!.roomCode;
                    controller.confirmCheckOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🧾 Checkout complete for Room $roomCode! Room sent to Housekeeping.'),
                        backgroundColor: const Color(0xFF007A87),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007A87),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              elevation: 0,
            ),
            child: const Text('Process & Settle Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}

// ---------------- COMMON HELPERS ----------------
class _SectionContainer extends StatelessWidget {
  final String step;
  final String title;
  final Widget child;

  const _SectionContainer({required this.step, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007A87),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    step,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _InfoFieldItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoFieldItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFCBD5E1))),
          child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ),
      ],
    );
  }
}

class _LineItemRow extends StatelessWidget {
  final String title;
  final String value;

  const _LineItemRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ],
    );
  }
}
