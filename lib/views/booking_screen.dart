import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/booking_controller.dart';
import '../models/room.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.hotel_rounded, color: Color(0xFF1E3A8A)),
            SizedBox(width: 8),
            Text(
              'RainStay Booking',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 900;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: isWideScreen
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _LeftSelectionSection()),
                          SizedBox(width: 24),
                          Expanded(flex: 2, child: _BookingSummaryCard()),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LeftSelectionSection(),
                          SizedBox(height: 24),
                          _BookingSummaryCard(),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// LEFT SECTION: DATE PICKER, GUEST FILTER, ROOM CATALOG
// ============================================================================
class _LeftSelectionSection extends StatelessWidget {
  const _LeftSelectionSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: '1. Select Dates', icon: Icons.calendar_today_outlined),
        SizedBox(height: 10),
        _DateSelectionCard(),
        SizedBox(height: 24),
        _SectionTitle(title: '2. Select Room', icon: Icons.bed_outlined),
        SizedBox(height: 10),
        _GuestFilterChips(),
        SizedBox(height: 12),
        _RoomList(),
      ],
    );
  }
}

// ---------------- DATE SELECTION CARD ----------------
class _DateSelectionCard extends StatelessWidget {
  const _DateSelectionCard();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final dateFormat = DateFormat('EEE, dd MMM yyyy');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _DatePickerTile(
                  label: 'Check-in Date',
                  dateText: controller.checkInDate != null
                      ? dateFormat.format(controller.checkInDate!)
                      : 'Select Date',
                  icon: Icons.login_rounded,
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.checkInDate ?? now,
                      firstDate: now.subtract(const Duration(days: 7)),
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      controller.setCheckInDate(picked);
                    }
                  },
                ),
                _DatePickerTile(
                  label: 'Check-out Date',
                  dateText: controller.checkOutDate != null
                      ? dateFormat.format(controller.checkOutDate!)
                      : 'Select Date',
                  icon: Icons.logout_rounded,
                  onTap: () async {
                    final now = DateTime.now();
                    final initial = controller.checkOutDate ??
                        (controller.checkInDate?.add(const Duration(days: 1)) ?? now.add(const Duration(days: 1)));
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: now.subtract(const Duration(days: 7)),
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      controller.setCheckOutDate(picked);
                    }
                  },
                ),
              ],
            ),
            if (controller.validationError != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.validationError!,
                        style: const TextStyle(
                          color: Color(0xFFB91C1C),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final String dateText;
  final IconData icon;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.dateText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                const SizedBox(height: 2),
                Text(
                  dateText,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- GUEST FILTER CHIPS ----------------
class _GuestFilterChips extends StatelessWidget {
  const _GuestFilterChips();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();

    final filterOptions = [
      {'label': 'All Rooms', 'value': null},
      {'label': '2+ Guests', 'value': 2},
      {'label': '3+ Guests', 'value': 3},
      {'label': '4 Guests', 'value': 4},
    ];

    return Wrap(
      spacing: 8,
      children: filterOptions.map((opt) {
        final isSelected = controller.guestFilter == opt['value'];
        return ChoiceChip(
          label: Text(opt['label'] as String),
          selected: isSelected,
          onSelected: (_) => controller.setGuestFilter(opt['value'] as int?),
          selectedColor: const Color(0xFF1E3A8A),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF334155),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFFCBD5E1),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      }).toList(),
    );
  }
}

// ---------------- ROOM LIST ----------------
class _RoomList extends StatelessWidget {
  const _RoomList();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final rooms = controller.filteredRooms;

    if (rooms.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text('No rooms found matching the guest filter.', style: TextStyle(color: Color(0xFF64748B))),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rooms.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final room = rooms[index];
        return _RoomTile(room: room);
      },
    );
  }
}

class _RoomTile extends StatelessWidget {
  final Room room;
  const _RoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
    final isAvailable = controller.isRoomAvailable(room);
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return InkWell(
      onTap: isAvailable ? () => controller.selectRoom(room) : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFFCBD5E1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // ROOM CODE BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                room.roomCode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isSelected ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ROOM TYPE & CAPACITY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.roomType,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        'Max Guests: ${room.maxGuests}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      if (!isAvailable) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Booked for dates',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // PRICE & SELECT BUTTON
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${currencyFormat.format(room.pricePerNight)} / night',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E3A8A)),
                ),
                const SizedBox(height: 4),
                Text(
                  isSelected ? '✓ Selected' : (isAvailable ? 'Click to select' : 'Unavailable'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// RIGHT SECTION: BOOKING SUMMARY CARD
// ============================================================================
class _BookingSummaryCard extends StatelessWidget {
  const _BookingSummaryCard();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final dateFormat = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: Color(0xFF1E3A8A)),
                SizedBox(width: 8),
                Text(
                  'Reservation Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
            const Divider(height: 28, color: Color(0xFFE2E8F0)),

            _SummaryRow(
              title: 'Selected Room',
              value: controller.selectedRoom != null
                  ? '${controller.selectedRoom!.roomType} (${controller.selectedRoom!.roomCode})'
                  : 'No room selected',
              isBold: controller.selectedRoom != null,
            ),
            const SizedBox(height: 10),
            _SummaryRow(
              title: 'Check-in',
              value: controller.checkInDate != null ? dateFormat.format(controller.checkInDate!) : 'Not selected',
            ),
            const SizedBox(height: 10),
            _SummaryRow(
              title: 'Check-out',
              value: controller.checkOutDate != null ? dateFormat.format(controller.checkOutDate!) : 'Not selected',
            ),
            const SizedBox(height: 10),
            _SummaryRow(
              title: 'Duration',
              value: '${controller.nights} night(s)',
              isBold: controller.nights > 0,
            ),
            if (controller.selectedRoom != null) ...[
              const SizedBox(height: 10),
              _SummaryRow(
                title: 'Rate per Night',
                value: currencyFormat.format(controller.selectedRoom!.pricePerNight),
              ),
            ],

            const Divider(height: 28, color: Color(0xFFE2E8F0)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                Text(
                  currencyFormat.format(controller.totalPrice),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: controller.totalPrice > 0 ? const Color(0xFF15803D) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: controller.canConfirmBooking
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🎉 Booking Confirmed! Room ${controller.selectedRoom!.roomCode} for ${controller.nights} night(s). Total: ${currencyFormat.format(controller.totalPrice)}',
                            ),
                            backgroundColor: const Color(0xFF15803D),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  disabledForegroundColor: const Color(0xFF94A3B8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  controller.canConfirmBooking
                      ? 'Confirm Booking (${currencyFormat.format(controller.totalPrice)})'
                      : 'Select Dates & Room to Book',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- HELPER WIDGETS ----------------
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E3A8A)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  const _SummaryRow({required this.title, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? const Color(0xFF0F172A) : const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}
