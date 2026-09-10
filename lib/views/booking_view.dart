import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/booking_controller.dart';
import '../models/room_model.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

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
    final activeIndex = _getTabIndex(controller.currentTab);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // TOP MANAGEMENT NAVIGATION HEADER
            const _ManagementNavBar(),

            // TAB VIEWS WITH INDEXEDSTACK FOR FLAWLESS SWITCHING & STATE RETENTION
            Expanded(
              child: IndexedStack(
                index: activeIndex,
                children: const [
                  _MainDashboardSection(),
                  _CheckInSection(),
                  _CheckOutSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 🧭 TOP MANAGEMENT NAVIGATION BAR
// =========================================================================
class _ManagementNavBar extends StatelessWidget {
  const _ManagementNavBar();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFCBD5E1), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // BRAND LOGO
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2B48),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'RainStay Pro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.4),
                ),
                Text('HOTEL POS & PMS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              ],
            ),
            const SizedBox(width: 24),

            // TAB SWITCH BUTTONS
            _NavTabButton(
              title: 'Main Dashboard',
              icon: Icons.dashboard_outlined,
              isSelected: controller.currentTab == 'dashboard',
              onTap: () => controller.switchTab('dashboard'),
            ),
            const SizedBox(width: 8),
            _NavTabButton(
              title: 'Guest Check-in',
              icon: Icons.login_rounded,
              isSelected: controller.currentTab == 'checkin',
              badgeCount: controller.availableRooms,
              onTap: () => controller.switchTab('checkin'),
            ),
            const SizedBox(width: 8),
            _NavTabButton(
              title: 'Guest Check-out',
              icon: Icons.logout_rounded,
              isSelected: controller.currentTab == 'checkout',
              badgeCount: controller.occupiedRooms,
              onTap: () => controller.switchTab('checkout'),
            ),

            const SizedBox(width: 24),

            // CLOCK DISPLAY
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('EEE, MMM d • hh:mm a').format(DateTime.now()),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final int? badgeCount;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F2B48) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? const Color(0xFF0F2B48) : const Color(0xFFCBD5E1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF334155)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                ),
              ),
              if (badgeCount != null && badgeCount! > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 📊 1. MAIN DASHBOARD VIEW
// =========================================================================
class _MainDashboardSection extends StatelessWidget {
  const _MainDashboardSection();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _ModuleCard(controller: controller)),
                    const SizedBox(width: 14),
                    Expanded(flex: 4, child: _KpiCard(controller: controller)),
                  ],
                )
              else ...[
                _ModuleCard(controller: controller),
                const SizedBox(height: 14),
                _KpiCard(controller: controller),
              ],

              const SizedBox(height: 16),

              // INTERACTIVE FLOOR VIEW & ROOM STATUS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Room Status - Interactive Floor View',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              'Click a room tile to manage check-in, checkout, or cleaning',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _LegendItem(color: const Color(0xFF10B981), label: 'Available'),
                            const SizedBox(width: 12),
                            _LegendItem(color: const Color(0xFF3B82F6), label: 'Occupied'),
                            const SizedBox(width: 12),
                            _LegendItem(color: const Color(0xFFEF4444), label: 'Dirty'),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Color(0xFFE2E8F0)),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: controller.rooms.map((room) {
                        final isOccupied = room.status == RoomStatus.occupied;
                        final isDirty = room.status == RoomStatus.dirty;
                        final statusColor = isOccupied
                            ? const Color(0xFF3B82F6)
                            : (isDirty ? const Color(0xFFEF4444) : const Color(0xFF10B981));

                        return InkWell(
                          onTap: () {
                            if (isOccupied) {
                              controller.switchTab('checkout', room: room);
                            } else if (isDirty) {
                              controller.markRoomClean(room);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('✨ Room ${room.roomCode} marked as clean & ready for guests!')),
                              );
                            } else {
                              controller.switchTab('checkin', room: room);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: statusColor, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      room.roomCode,
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF0F2B48)),
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  room.roomType,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF334155)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isOccupied
                                      ? (room.currentGuest ?? 'Occupied')
                                      : (isDirty ? 'Dirty (Click to Clean)' : 'Available (Click to Book)'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isOccupied ? const Color(0xFF2563EB) : (isDirty ? const Color(0xFFDC2626) : const Color(0xFF059669)),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final BookingController controller;
  const _ModuleCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Operational Modules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ModuleTile(
                title: 'Guest Check-in',
                icon: Icons.how_to_reg_outlined,
                color: const Color(0xFF059669),
                onTap: () => controller.switchTab('checkin'),
              ),
              _ModuleTile(
                title: 'Guest Check-Out',
                icon: Icons.meeting_room_outlined,
                color: const Color(0xFFE11D48),
                onTap: () => controller.switchTab('checkout'),
              ),
              _ModuleTile(
                title: 'Housekeeping',
                icon: Icons.cleaning_services_outlined,
                color: const Color(0xFFD97706),
                badge: '${controller.dirtyRooms} dirty',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${controller.dirtyRooms} rooms currently in housekeeping/cleaning.')),
                  );
                },
              ),
              _ModuleTile(
                title: 'Room Catalog',
                icon: Icons.bed_outlined,
                color: const Color(0xFF6366F1),
                onTap: () => controller.switchTab('checkin'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final BookingController controller;
  const _KpiCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Operational Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _KpiBox(title: 'Occupancy', value: '${controller.occupancyRate}%', isPrimary: true)),
              const SizedBox(width: 8),
              Expanded(child: _KpiBox(title: 'Available', value: '${controller.availableRooms}')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _KpiBox(title: 'Occupied', value: '${controller.occupiedRooms}')),
              const SizedBox(width: 8),
              Expanded(child: _KpiBox(title: 'Dirty/Turnover', value: '${controller.dirtyRooms}')),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 🏨 2. GUEST CHECK-IN SECTION
// =========================================================================
class _CheckInSection extends StatelessWidget {
  const _CheckInSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _PanelContainer(title: '1. Select Stay Dates & Room', child: _CheckInPanel1())),
                    SizedBox(width: 14),
                    Expanded(flex: 4, child: _PanelContainer(title: '2. Review & Guest Details', child: _CheckInPanel2())),
                    SizedBox(width: 14),
                    Expanded(flex: 3, child: _PanelContainer(title: '3. Finalize Check-in & Payment', child: _CheckInPanel3())),
                  ],
                )
              : const Column(
                  children: [
                    _PanelContainer(title: '1. Select Stay Dates & Room', child: _CheckInPanel1()),
                    SizedBox(height: 14),
                    _PanelContainer(title: '2. Review & Guest Details', child: _CheckInPanel2()),
                    SizedBox(height: 14),
                    _PanelContainer(title: '3. Finalize Check-in & Payment', child: _CheckInPanel3()),
                  ],
                ),
        );
      },
    );
  }
}

class _CheckInPanel1 extends StatelessWidget {
  const _CheckInPanel1();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stay Dates (Check-in ➔ Check-out)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7)),
              lastDate: now.add(const Duration(days: 365)),
              initialDateRange: controller.dateRange,
              helpText: 'Select Check-in and Check-out',
            );
            if (picked != null) {
              controller.setDateRange(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, size: 16, color: Color(0xFF0F2B48)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.checkInDate != null && controller.checkOutDate != null
                        ? '${dateFormat.format(controller.checkInDate!)}  —  ${dateFormat.format(controller.checkOutDate!)}'
                        : 'Pick dates (DeLorean not included)',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),

        if (controller.errorMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFFCA5A5))),
            child: Text(controller.errorMessage!, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],

        const SizedBox(height: 14),
        const Text('Available Inventory', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 6),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFD),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: controller.rooms.where((r) => r.status != RoomStatus.occupied).map((room) {
              final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
              return InkWell(
                onTap: () => controller.selectRoom(room),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: isSelected ? const Color(0xFFEEF2FF) : Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(width: 50, child: Text(room.roomCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F2B48)))),
                      Expanded(child: Text(room.roomType, style: const TextStyle(fontSize: 12))),
                      Text(currencyFormat.format(room.pricePerNight), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? const Color(0xFF0F2B48) : Colors.grey, size: 16),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CheckInPanel2 extends StatelessWidget {
  const _CheckInPanel2();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final room = controller.selectedRoom;

    if (room == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Select a room in Panel 1 to review details', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE2C98A), Color(0xFFB58A38), Color(0xFFE2C98A)]),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF8C641E)),
              ),
              child: Text(room.roomCode, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2C1C05), fontSize: 13)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(room.roomType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F2B48))),
            ),
          ],
        ),
        const SizedBox(height: 12),

        const Text('Guest Name', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        TextFormField(
          initialValue: controller.guestName ?? 'Guest Traveler',
          onChanged: controller.setGuestName,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(child: _InfoField(label: 'Rent / Night', value: currencyFormat.format(room.pricePerNight))),
            const SizedBox(width: 8),
            Expanded(child: _InfoField(label: 'Max Occupancy', value: '${room.maxGuests} Guests')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _InfoField(label: 'Nights Duration', value: '${controller.nights} night(s)')),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoField(
                label: 'Check-out Date',
                value: controller.checkOutDate != null ? DateFormat('dd/MM/yyyy').format(controller.checkOutDate!) : '—',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckInPanel3 extends StatelessWidget {
  const _CheckInPanel3();

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
            const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF0F2B48))),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 12),
        _SummaryLine(title: 'Room Charges', value: currencyFormat.format(controller.roomCharge)),
        const SizedBox(height: 4),
        const _SummaryLine(title: 'Extra Charges', value: '₹0.00'),
        const SizedBox(height: 4),
        const _SummaryLine(title: 'Tax / GST', value: '₹0.00'),
        const SizedBox(height: 16),

        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: controller.isReadyToBook
                ? () {
                    controller.confirmCheckIn();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Check-in Completed Successfully! Room assigned.'),
                        backgroundColor: Color(0xFF15803D),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F2B48),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Complete Check-in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 🚪 3. GUEST CHECK-OUT SECTION
// =========================================================================
class _CheckOutSection extends StatelessWidget {
  const _CheckOutSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _PanelContainer(title: '1. Identify Departing Guest', child: _CheckOutPanel1())),
                    SizedBox(width: 14),
                    Expanded(flex: 4, child: _PanelContainer(title: '2. Review & Finalize Bill', child: _CheckOutPanel2())),
                    SizedBox(width: 14),
                    Expanded(flex: 3, child: _PanelContainer(title: '3. Payment & Check-out', child: _CheckOutPanel3())),
                  ],
                )
              : const Column(
                  children: [
                    _PanelContainer(title: '1. Identify Departing Guest', child: _CheckOutPanel1()),
                    SizedBox(height: 14),
                    _PanelContainer(title: '2. Review & Finalize Bill', child: _CheckOutPanel2()),
                    SizedBox(height: 14),
                    _PanelContainer(title: '3. Payment & Check-out', child: _CheckOutPanel3()),
                  ],
                ),
        );
      },
    );
  }
}

class _CheckOutPanel1 extends StatelessWidget {
  const _CheckOutPanel1();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final occupiedRooms = controller.rooms.where((r) => r.status == RoomStatus.occupied).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Occupied Room', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 6),
        if (occupiedRooms.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No rooms currently occupied.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFBFD),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Column(
              children: occupiedRooms.map((room) {
                final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
                return InkWell(
                  onTap: () => controller.selectRoom(room),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: isSelected ? const Color(0xFFEEF2FF) : Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFE2C98A), Color(0xFFB58A38)]),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(room.roomCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF2C1C05))),
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
                        Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? const Color(0xFF0F2B48) : Colors.grey, size: 18),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _CheckOutPanel2 extends StatelessWidget {
  const _CheckOutPanel2();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final room = controller.selectedRoom;

    if (room == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Select an occupied room from Panel 1', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '[Room ${room.roomCode}] — ${room.currentGuest ?? 'Guest'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F2B48)),
        ),
        Text(
          '(Nights: ${controller.nights}, Rate: ${currencyFormat.format(room.pricePerNight)}, Total: ${currencyFormat.format(controller.roomCharge)})',
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),

        const Text('Additional Charges (Mini-bar, Laundry, etc.)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 6),

        if (room.extraCharges.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No extra charges recorded.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: room.extraCharges.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Room ${room.roomCode} Total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF0F2B48))),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckOutPanel3 extends StatelessWidget {
  const _CheckOutPanel3();

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
            const Text('Total Amount Due', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(currencyFormat.format(controller.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF0F2B48))),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 12),

        const Text('Payment Method', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Credit Card / UPI / Cash', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: controller.selectedRoom != null
                ? () {
                    final roomCode = controller.selectedRoom!.roomCode;
                    controller.confirmCheckOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🧾 Checkout & Payment Complete for Room $roomCode! Marked as Dirty/Turnover.'),
                        backgroundColor: const Color(0xFF15803D),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F2B48),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Process Payment & Check-out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}

// ---------------- COMMON PANEL CONTAINER ----------------
class _PanelContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _PanelContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFF0F2B48),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ---------------- DASHBOARD WIDGETS ----------------
class _ModuleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const _ModuleTile({
    required this.title,
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E293B)),
            ),
            if (badge != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _KpiBox extends StatelessWidget {
  final String title;
  final String value;
  final bool isPrimary;

  const _KpiBox({required this.title, required this.value, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isPrimary ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, color: isPrimary ? const Color(0xFF1D4ED8) : const Color(0xFF64748B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: isPrimary ? const Color(0xFF1E40AF) : const Color(0xFF0F172A))),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFCBD5E1))),
          child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
      ],
    );
  }
}
