import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../models/room.dart';

class ActiveStayRow extends StatelessWidget {
  final Room room;
  final BookingController controller;
  final bool isCompact;

  const ActiveStayRow({
    super.key,
    required this.room,
    required this.controller,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useCompact = isCompact || constraints.maxWidth < 480;

        if (useCompact) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        room.roomCode,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        room.currentGuest ?? 'Guest',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${currencyFormat.format(room.pricePerNight)}/nt',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        room.checkInDate != null && room.checkOutDate != null
                            ? '${dateFormat.format(room.checkInDate!)} → ${dateFormat.format(room.checkOutDate!)}'
                            : 'Active Stay',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => controller.switchTab('checkout', room: room),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7F5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.mintBorder),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryTeal),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  room.roomCode,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.currentGuest ?? 'Guest',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      room.roomType,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                room.checkInDate != null && room.checkOutDate != null
                    ? '${dateFormat.format(room.checkInDate!)} → ${dateFormat.format(room.checkOutDate!)}'
                    : 'Active Stay',
                style: const TextStyle(fontSize: 12, color: AppColors.textBody, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Text(
                '${currencyFormat.format(room.pricePerNight)}/nt',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textDark),
              ),
              const SizedBox(width: 14),
              InkWell(
                onTap: () => controller.switchTab('checkout', room: room),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.mintBorder),
                  ),
                  child: const Text(
                    'Checked Out',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryTeal),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
