import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../models/room.dart';
import '../widgets/active_stay_row.dart';
import '../widgets/cityscape_painter.dart';
import '../widgets/date_range_picker_dialog.dart';
import '../widgets/room_card_tile.dart';
import '../widgets/section_container.dart';
import '../widgets/stat_card.dart';
import '../widgets/teal_pos_nav_bar.dart';

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
      backgroundColor: AppColors.mintBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // MAIN VIEW CONTAINER
            Column(
              children: [
                const TealPOSNavBar(),
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

            // DECORATIVE BOTTOM CITYSCAPE & WAVES
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 75,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: IllustratedCityscapePainter(),
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
// 📊 1. RESPONSIVE DASHBOARD VIEW
// ============================================================================
class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP DASHBOARD + ACTIVE STAYS SECTION
              if (isDesktop)
                SizedBox(
                  height: 228,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // LEFT: 2x2 STAT CARDS (flex: 5)
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
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
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: StatCard(
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
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
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: StatCard(
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
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 14),

                      // RIGHT: ACTIVE GUEST STAYS CARD (flex: 6)
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.people_alt_rounded, color: AppColors.primaryTeal, size: 17),
                                      SizedBox(width: 8),
                                      Text(
                                        'Active Guest Stays',
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.availableGreen, shape: BoxShape.circle)),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${controller.occupiedRoomsCount} occupied',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: controller.occupiedRoomsList.isEmpty
                                    ? const Center(
                                        child: Text('No active guest stays right now.', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: controller.occupiedRoomsList.length,
                                        itemBuilder: (context, index) {
                                          return ActiveStayRow(
                                            room: controller.occupiedRoomsList[index],
                                            controller: controller,
                                            isCompact: true,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                LayoutBuilder(
                  builder: (context, cardConstraints) {
                    final isMobileSmall = cardConstraints.maxWidth < 360;
                    if (isMobileSmall) {
                      return Column(
                        children: [
                          StatCard(
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
                          const SizedBox(height: 8),
                          StatCard(
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
                          const SizedBox(height: 8),
                          StatCard(
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
                          const SizedBox(height: 8),
                          StatCard(
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
                        ],
                      );
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
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
                            const SizedBox(width: 8),
                            Expanded(
                              child: StatCard(
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
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
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
                            const SizedBox(width: 8),
                            Expanded(
                              child: StatCard(
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
                      ],
                    );
                  },
                ),

                const SizedBox(height: 14),

                // MOBILE ACTIVE STAYS
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.people_alt_rounded, color: AppColors.primaryTeal, size: 17),
                              SizedBox(width: 8),
                              Text(
                                'Active Guest Stays',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          Text(
                            '${controller.occupiedRoomsCount} occupied',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (controller.occupiedRoomsList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text('No active guest stays right now.', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                          ),
                        )
                      else
                        ...controller.occupiedRoomsList.map((room) {
                          return ActiveStayRow(
                            room: room,
                            controller: controller,
                          );
                        }),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // UNBOXED ROOM INVENTORY GRID SECTION
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.meeting_room_rounded, color: AppColors.primaryTeal, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Room Inventory',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.mintHighlight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${controller.totalRooms} Rooms',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    children: const [
                      LegendDot(color: AppColors.availableGreen, label: 'Available'),
                      LegendDot(color: AppColors.occupiedBlue, label: 'Occupied'),
                      LegendDot(color: AppColors.dirtyRed, label: 'Dirty'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              LayoutBuilder(
                builder: (context, gridConstraints) {
                  final screenWidth = gridConstraints.maxWidth;
                  int crossAxisCount = 2;
                  if (screenWidth >= 1400) {
                    crossAxisCount = 7;
                  } else if (screenWidth >= 1150) {
                    crossAxisCount = 6;
                  } else if (screenWidth >= 900) {
                    crossAxisCount = 5;
                  } else if (screenWidth >= 650) {
                    crossAxisCount = 4;
                  } else if (screenWidth >= 440) {
                    crossAxisCount = 3;
                  }

                  const double spacing = 10.0;
                  final totalSpacing = spacing * (crossAxisCount - 1);
                  final itemWidth = (screenWidth - totalSpacing) / crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: controller.rooms.map((room) {
                      return RoomCardTile(
                        room: room,
                        controller: controller,
                        width: itemWidth,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// 🏨 2. CHECK-IN VIEW
// ============================================================================
class _CheckInView extends StatelessWidget {
  const _CheckInView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
          child: isDesktop
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SectionContainer(
                        icon: Icons.calendar_month_rounded,
                        title: 'Dates & Room Selection',
                        subtitle: 'Select stay dates and available room',
                        child: _CheckInDatesContent(),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      flex: 4,
                      child: SectionContainer(
                        icon: Icons.person_outline_rounded,
                        title: 'Guest & Rate Details',
                        subtitle: 'Enter guest information and rate details',
                        child: _CheckInDetailsContent(),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: SectionContainer(
                        icon: Icons.credit_card_rounded,
                        title: 'Summary & Confirmation',
                        subtitle: 'Review total and complete check-in',
                        child: _CheckInSummaryContent(),
                      ),
                    ),
                  ],
                )
              : const Column(
                  children: [
                    SectionContainer(
                      icon: Icons.calendar_month_rounded,
                      title: 'Dates & Room Selection',
                      subtitle: 'Select stay dates and available room',
                      child: _CheckInDatesContent(),
                    ),
                    SizedBox(height: 14),
                    SectionContainer(
                      icon: Icons.person_outline_rounded,
                      title: 'Guest & Rate Details',
                      subtitle: 'Enter guest information and rate details',
                      child: _CheckInDetailsContent(),
                    ),
                    SizedBox(height: 14),
                    SectionContainer(
                      icon: Icons.credit_card_rounded,
                      title: 'Summary & Confirmation',
                      subtitle: 'Review total and complete check-in',
                      child: _CheckInSummaryContent(),
                    ),
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
        const Text('STAY DATES', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showModernDateRangePicker(
              context,
              initialRange: controller.dateRange,
            );
            if (picked != null) {
              controller.setDateRange(picked);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.date_range_rounded, size: 16, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.checkInDate != null && controller.checkOutDate != null
                        ? '${dateFormat.format(controller.checkInDate!)} → ${dateFormat.format(controller.checkOutDate!)}'
                        : 'Select Check-in & Check-out Dates',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (controller.nights > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primaryTeal, borderRadius: BorderRadius.circular(4)),
                    child: Text('${controller.nights} nt', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
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

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('AVAILABLE INVENTORY', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
            Text('${controller.availableRoomsCount} of ${controller.totalRooms} rooms', style: const TextStyle(fontSize: 11, color: AppColors.textDisabled)),
          ],
        ),
        const SizedBox(height: 8),

        Column(
          children: controller.rooms.where((r) => r.status != RoomStatus.occupied).map((room) {
            final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => controller.selectRoom(room),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF0FDFA) : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.mintBorder : AppColors.lightBorder,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryTeal : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          room.roomCode,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textBody,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(room.roomType, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textDark), overflow: TextOverflow.ellipsis),
                            Text('${currencyFormat.format(room.pricePerNight)} / night', style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.primaryTeal : const Color(0xFFCBD5E1),
                        size: 18,
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
          child: Text('Select a room in Step 1 to review details', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BLUE-TINTED ROOM SUMMARY BANNER
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            children: [
              const Icon(Icons.hotel_rounded, color: Color(0xFF0284C7), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room ${room.roomCode}  -  ${room.roomType}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${currencyFormat.format(room.pricePerNight)}/night • Max ${room.maxGuests} Guests',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        const Text('Guest Name *', style: TextStyle(fontSize: 10.5, color: AppColors.textMuted, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        TextFormField(
          key: ValueKey(room.roomCode),
          initialValue: controller.guestName,
          onChanged: controller.setGuestName,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Enter guest name (e.g. Adarsh, Riyas)',
            hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textDisabled, fontWeight: FontWeight.normal),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          ),
        ),
        const SizedBox(height: 12),

        // GUEST COUNTERS (ADULTS & CHILDREN)
        Row(
          children: [
            Expanded(
              child: GuestCounterBox(
                label: 'Adults',
                sublabel: 'Max ${room.maxGuests}',
                count: controller.adultsCount,
                isExceeded: controller.adultsCount > room.maxGuests,
                onDecrement: controller.adultsCount > 1
                    ? () => controller.setAdultsCount(controller.adultsCount - 1)
                    : null,
                onIncrement: () => controller.setAdultsCount(controller.adultsCount + 1),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GuestCounterBox(
                label: 'Children',
                sublabel: 'Not counted in cap',
                count: controller.childrenCount,
                isExceeded: false,
                onDecrement: controller.childrenCount > 0
                    ? () => controller.setChildrenCount(controller.childrenCount - 1)
                    : null,
                onIncrement: () => controller.setChildrenCount(controller.childrenCount + 1),
              ),
            ),
          ],
        ),

        if (controller.adultsCount > room.maxGuests) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFFCA5A5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Adults count (${controller.adultsCount}) exceeds room capacity (${room.maxGuests} max)',
                    style: const TextStyle(color: Color(0xFFDC2626), fontSize: 10.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: InfoFieldItem(label: 'Price / Night', value: currencyFormat.format(room.pricePerNight))),
            const SizedBox(width: 8),
            Expanded(child: InfoFieldItem(label: 'Room Floor', value: 'Floor ${room.floor}')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InfoFieldItem(
                label: 'Duration',
                value: '${controller.nights} night(s)',
                suffixIcon: Icons.calendar_today_outlined,
                onTap: () async {
                  final picked = await showModernDateRangePicker(
                    context,
                    initialRange: controller.dateRange,
                  );
                  if (picked != null) {
                    controller.setDateRange(picked);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InfoFieldItem(
                label: 'Check-out Date',
                value: controller.checkOutDate != null ? DateFormat('dd MMM').format(controller.checkOutDate!) : 'Select',
                suffixIcon: Icons.edit_calendar_rounded,
                onTap: () async {
                  final picked = await showModernDateRangePicker(
                    context,
                    initialRange: controller.dateRange,
                  );
                  if (picked != null) {
                    controller.setDateRange(picked);
                  }
                },
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
        // GRAND TOTAL BLUE BANNER
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0369A1))),
              Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textDark)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        LineItemRow(title: 'Room Rent', value: currencyFormat.format(controller.roomCharge)),
        const SizedBox(height: 6),
        const LineItemRow(title: 'Taxes / Fees (0%)', value: '₹0.00'),
        const SizedBox(height: 16),

        SizedBox(
          height: 44,
          child: ElevatedButton.icon(
            onPressed: controller.canConfirmBooking
                ? () {
                    controller.confirmCheckIn();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Check-in completed successfully!'),
                        backgroundColor: AppColors.primaryTeal,
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.login_rounded, size: 16),
            label: const Text('Complete Check-in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 🚪 3. CHECK-OUT VIEW
// ============================================================================
class _CheckOutView extends StatelessWidget {
  const _CheckOutView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
          child: isDesktop
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SectionContainer(
                        icon: Icons.person_rounded,
                        title: 'Departing Guest Selection',
                        subtitle: 'Select a guest to proceed with checkout',
                        child: _CheckOutSelectContent(),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      flex: 4,
                      child: SectionContainer(
                        icon: Icons.description_rounded,
                        title: 'Itemized Invoice Review',
                        subtitle: 'View charges and additional items',
                        child: _CheckOutBillContent(),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: SectionContainer(
                        icon: Icons.credit_card_rounded,
                        title: 'Settlement & Payment',
                        subtitle: 'Choose payment method and complete checkout',
                        child: _CheckOutPaymentContent(),
                      ),
                    ),
                  ],
                )
              : const Column(
                  children: [
                    SectionContainer(
                      icon: Icons.person_rounded,
                      title: 'Departing Guest Selection',
                      subtitle: 'Select a guest to proceed with checkout',
                      child: _CheckOutSelectContent(),
                    ),
                    SizedBox(height: 14),
                    SectionContainer(
                      icon: Icons.description_rounded,
                      title: 'Itemized Invoice Review',
                      subtitle: 'View charges and additional items',
                      child: _CheckOutBillContent(),
                    ),
                    SizedBox(height: 14),
                    SectionContainer(
                      icon: Icons.credit_card_rounded,
                      title: 'Settlement & Payment',
                      subtitle: 'Choose payment method and complete checkout',
                      child: _CheckOutPaymentContent(),
                    ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('OCCUPIED ROOMS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
            Text('${occupiedRooms.length} of ${controller.totalRooms} rooms', style: const TextStyle(fontSize: 11, color: AppColors.textDisabled)),
          ],
        ),
        const SizedBox(height: 10),
        if (occupiedRooms.isEmpty)
          const Padding(
            padding: EdgeInsets.all(28.0),
            child: Center(
              child: Text('No occupied rooms to check out.', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
            ),
          )
        else
          Column(
            children: occupiedRooms.map((room) {
              final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => controller.selectRoomForCheckout(room),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF0FDFA) : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.mintBorder : AppColors.lightBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryTeal : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            room.roomCode,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: isSelected ? Colors.white : AppColors.textBody,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(room.currentGuest ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5), overflow: TextOverflow.ellipsis),
                              Text(room.roomType, style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: AppColors.availableGreen, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                          color: isSelected ? AppColors.primaryTeal : const Color(0xFFCBD5E1),
                          size: 18,
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
    final dateFormat = DateFormat('dd MMM');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final room = controller.selectedRoom;

    if (room == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(36.0),
          child: Text('Select an occupied room from Step 1', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BLUE-TINTED SUMMARY BANNER
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            children: [
              const Icon(Icons.hotel_rounded, color: Color(0xFF0284C7), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room ${room.roomCode}  -  ${room.currentGuest ?? 'Guest'}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room.checkInDate != null && room.checkOutDate != null
                          ? 'Check-in: ${dateFormat.format(room.checkInDate!)}  •  Check-out: ${dateFormat.format(room.checkOutDate!)} (${controller.nights} Nights)'
                          : '${controller.nights} night(s) stay',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        const Text('Incidental & Extra Charges', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textBody)),
        const SizedBox(height: 8),

        if (room.extraCharges.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No extra charges recorded.', style: TextStyle(fontSize: 11, color: AppColors.textDisabled)),
          )
        else
          ...room.extraCharges.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                  Text(currencyFormat.format(item.amount), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
            );
          }),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Room ${room.roomCode} Total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark)),
              Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.primaryTeal)),
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
        // GRAND TOTAL BLUE BANNER
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0369A1))),
              Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textDark)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        const Text('Payment Method', style: TextStyle(fontSize: 11, color: AppColors.textBody, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.credit_card_rounded, size: 16, color: AppColors.textMuted),
                  SizedBox(width: 8),
                  Text('UPI / Card / Cash', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
              Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textMuted),
            ],
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 44,
          child: ElevatedButton.icon(
            onPressed: controller.selectedRoom != null
                ? () {
                    final roomCode = controller.selectedRoom!.roomCode;
                    controller.confirmCheckOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🧾 Checkout complete for Room $roomCode! Room sent to Housekeeping.'),
                        backgroundColor: AppColors.primaryTeal,
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.point_of_sale_rounded, size: 16),
            label: const Text('Process & Settle Checkout  →', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
