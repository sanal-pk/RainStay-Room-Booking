import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/booking_controller.dart';
import '../models/room_model.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth >= 960;
          return isLargeScreen ? const _PosDesktopLayout() : const _MobileTabletLayout();
        },
      ),
    );
  }
}

// ==========================================
// 💻 LARGE SCREEN / POS DESKTOP LAYOUT
// ==========================================
class _PosDesktopLayout extends StatefulWidget {
  const _PosDesktopLayout();

  @override
  State<_PosDesktopLayout> createState() => _PosDesktopLayoutState();
}

class _PosDesktopLayoutState extends State<_PosDesktopLayout> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final filteredRooms = _selectedFilter == 'All'
        ? controller.rooms
        : controller.rooms.where((r) => r.roomType == _selectedFilter).toList();

    return Row(
      children: [
        // LEFT: POS ROOM CATALOG
        Expanded(
          flex: 6,
          child: Column(
            children: [
              // POS TOP BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.point_of_sale_rounded, color: Colors.indigo, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RainStay POS Terminal',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                        ),
                        Text(
                          'Front Desk • Station #01 (Online)',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // FILTER CHIPS
                    Wrap(
                      spacing: 8,
                      children: ['All', 'Deluxe Room', 'Executive Suite', 'Family Room'].map((type) {
                        final isSelected = _selectedFilter == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedFilter = type),
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF334155),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          backgroundColor: const Color(0xFFF8FAFC),
                          side: BorderSide(
                            color: isSelected ? Colors.indigo : const Color(0xFFE2E8F0),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // ROOM GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = filteredRooms[index];
                      return _PosRoomTile(room: room);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // RIGHT: POS REGISTER / SUMMARY SIDEBAR
        const SizedBox(
          width: 420,
          child: _PosRegisterSidebar(),
        ),
      ],
    );
  }
}

// ---------------- POS ROOM TILE ----------------
class _PosRoomTile extends StatelessWidget {
  final Room room;
  const _PosRoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final isSelected = controller.selectedRoom?.roomCode == room.roomCode;
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.selectRoom(room),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.indigo : const Color(0xFFE2E8F0),
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.indigo.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    room.image,
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 125,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.hotel, size: 36, color: Colors.grey)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.indigo : Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        room.roomCode,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people_alt, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${room.maxGuests}',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            room.description,
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${currencyFormat.format(room.pricePerNight)}/nt',
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                            color: isSelected ? Colors.indigo : Colors.grey.shade400,
                            size: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- POS REGISTER SIDEBAR ----------------
class _PosRegisterSidebar extends StatelessWidget {
  const _PosRegisterSidebar();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          // REGISTER HEADER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.receipt_rounded, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text(
                      'Booking Ticket',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: controller.clearSelection,
                  icon: const Icon(Icons.refresh, size: 16, color: Color(0xFFEF4444)),
                  label: const Text('Reset', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                ),
              ],
            ),
          ),

          // TICKET BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DATE RANGE PICKER WIDGET
                  const Text('STAY DATES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 8),
                  const _DateRangePickerButton(),
                  const SizedBox(height: 20),

                  // VALIDATION ERROR ALERT
                  if (controller.errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.errorMessage!,
                              style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // SELECTED ITEM RECEIPT
                  const Text('SELECTED ROOM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 8),
                  if (controller.selectedRoom != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.selectedRoom!.displayName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                currencyFormat.format(controller.selectedRoom!.pricePerNight),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Max Guests: ${controller.selectedRoom!.maxGuests} • Nightly rate',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.touch_app_outlined, color: Color(0xFF94A3B8), size: 28),
                          SizedBox(height: 6),
                          Text(
                            'Select a room from the grid',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),

                  // CALCULATION BREAKDOWN
                  _ReceiptRow(
                    title: 'Duration',
                    value: controller.nights > 0 ? '${controller.nights} night(s)' : '—',
                  ),
                  const SizedBox(height: 8),
                  _ReceiptRow(
                    title: 'Rate / Night',
                    value: controller.selectedRoom != null
                        ? currencyFormat.format(controller.selectedRoom!.pricePerNight)
                        : '—',
                  ),
                  const SizedBox(height: 8),
                  _ReceiptRow(
                    title: 'Taxes & Resort Fees',
                    value: 'Included (0% hidden charges)',
                    valueColor: const Color(0xFF16A34A),
                  ),
                ],
              ),
            ),
          ),

          // REGISTER FOOTER / CHECKOUT BAR
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(
                      currencyFormat.format(controller.totalPrice),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: controller.totalPrice > 0 ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isReadyToBook
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '🧾 POS Order Placed! ${controller.selectedRoom!.displayName} booked for ${controller.nights} nights. Total: ${currencyFormat.format(controller.totalPrice)}',
                                ),
                                backgroundColor: const Color(0xFF16A34A),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      disabledForegroundColor: const Color(0xFF94A3B8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      controller.isReadyToBook
                          ? 'Confirm & Collect ${currencyFormat.format(controller.totalPrice)}'
                          : 'Select Dates & Room to Book',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- COMMON DATE RANGE PICKER BUTTON ----------------
class _DateRangePickerButton extends StatelessWidget {
  const _DateRangePickerButton();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final dateFormat = DateFormat('dd MMM yyyy');

    final dateText = (controller.checkInDate != null && controller.checkOutDate != null)
        ? '${dateFormat.format(controller.checkInDate!)}  ➔  ${dateFormat.format(controller.checkOutDate!)}'
        : 'Select Check-in & Check-out';

    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year, now.month, now.day),
          lastDate: now.add(const Duration(days: 365)),
          initialDateRange: controller.dateRange,
          helpText: 'Select Stay Period',
          cancelText: 'Cancel',
          confirmText: 'Apply Dates',
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Colors.indigo,
                    ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          controller.setDateRange(picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range_rounded, color: Colors.indigo, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                dateText,
                style: TextStyle(
                  fontWeight: (controller.checkInDate != null) ? FontWeight.bold : FontWeight.w500,
                  color: (controller.checkInDate != null) ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 📱 MOBILE & TABLET RESPONSIVE LAYOUT
// ==========================================
class _MobileTabletLayout extends StatelessWidget {
  const _MobileTabletLayout();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.hotel_rounded, color: Colors.indigo),
            SizedBox(width: 8),
            Text('RainStay Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEP 1: DATE RANGE
            const Text('1. Pick Dates (Check-in ➔ Check-out)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            const _DateRangePickerButton(),
            if (controller.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
            const SizedBox(height: 20),

            // STEP 2: ROOM SELECTION
            const Text('2. Select Room', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.rooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final room = controller.rooms[index];
                return _PosRoomTile(room: room);
              },
            ),
            const SizedBox(height: 20),

            // STEP 3: SUMMARY
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(height: 20),
                    _ReceiptRow(
                      title: 'Room',
                      value: controller.selectedRoom?.displayName ?? 'Not selected',
                    ),
                    const SizedBox(height: 6),
                    _ReceiptRow(
                      title: 'Stay',
                      value: '${controller.nights} night(s)',
                    ),
                    const SizedBox(height: 6),
                    _ReceiptRow(
                      title: 'Total',
                      value: currencyFormat.format(controller.totalPrice),
                      valueColor: Colors.indigo,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: controller.isReadyToBook
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '🎉 Booked ${controller.selectedRoom!.displayName} for ${controller.nights} night(s)! Total: ${currencyFormat.format(controller.totalPrice)}',
                                    ),
                                    backgroundColor: const Color(0xFF16A34A),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          controller.isReadyToBook
                              ? 'Book Now (${currencyFormat.format(controller.totalPrice)})'
                              : 'Select Dates & Room',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- RECEIPT ROW HELPER ----------------
class _ReceiptRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _ReceiptRow({required this.title, required this.value, this.valueColor});

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
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
