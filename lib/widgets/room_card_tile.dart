import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../models/room.dart';

class RoomCardTile extends StatelessWidget {
  final Room room;
  final BookingController controller;
  final double width;

  const RoomCardTile({
    super.key,
    required this.room,
    required this.controller,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = room.status == RoomStatus.occupied;
    final isDirty = room.status == RoomStatus.dirty;

    final dotColor = isOccupied
        ? AppColors.occupiedBlue
        : (isDirty ? AppColors.dirtyRed : AppColors.availableGreen);

    final bottomBorderColor = isOccupied
        ? AppColors.occupiedBlue
        : (isDirty ? AppColors.dirtyRed : AppColors.availableGreen);

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
        width: width,
        constraints: const BoxConstraints(minHeight: 132),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                        child: Icon(icon, size: 16, color: iconColor),
                      ),
                      Text(
                        room.roomCode,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.textDark),
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          room.roomType,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₹${room.pricePerNight.toInt()}/nt',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: pillBg,
                      borderRadius: BorderRadius.circular(10),
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
              height: 3.5,
              color: bottomBorderColor,
            ),
          ],
        ),
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
