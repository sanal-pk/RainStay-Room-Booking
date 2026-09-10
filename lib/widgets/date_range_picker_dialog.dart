import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

Future<DateTimeRange?> showModernDateRangePicker(
  BuildContext context, {
  DateTimeRange? initialRange,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => ModernDateRangePickerDialog(initialRange: initialRange),
  );
}

class ModernDateRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialRange;

  const ModernDateRangePickerDialog({super.key, this.initialRange});

  @override
  State<ModernDateRangePickerDialog> createState() => _ModernDateRangePickerDialogState();
}

class _ModernDateRangePickerDialogState extends State<ModernDateRangePickerDialog> {
  late DateTime _displayedMonth;
  DateTime? _startDate;
  DateTime? _endDate;
  late final DateTime _today;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _startDate = widget.initialRange?.start != null && !widget.initialRange!.start.isBefore(_today)
        ? widget.initialRange!.start
        : _today;
    _endDate = widget.initialRange?.end != null && !widget.initialRange!.end.isBefore(_startDate!)
        ? widget.initialRange!.end
        : _today.add(const Duration(days: 2));
    _displayedMonth = DateTime(_startDate!.year, _startDate!.month);
  }

  void _onDateTapped(DateTime date) {
    if (date.isBefore(_today)) return;

    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (_startDate != null && _endDate == null) {
        if (date.isBefore(_startDate!)) {
          _startDate = date;
        } else if (date.isAtSameMomentAs(_startDate!)) {
          _endDate = date.add(const Duration(days: 1));
        } else {
          _endDate = date;
        }
      }
    });
  }

  void _applyPreset(int nights) {
    setState(() {
      _startDate = _today;
      _endDate = _today.add(Duration(days: nights));
      _displayedMonth = DateTime(_today.year, _today.month);
    });
  }

  void _applyWeekendPreset() {
    final now = _today;
    int daysUntilFriday = (DateTime.friday - now.weekday) % 7;
    if (daysUntilFriday == 0 && now.hour >= 18) {
      daysUntilFriday = 7;
    }
    final nextFriday = now.add(Duration(days: daysUntilFriday));
    final nextSunday = nextFriday.add(const Duration(days: 2));

    setState(() {
      _startDate = nextFriday;
      _endDate = nextSunday;
      _displayedMonth = DateTime(nextFriday.year, nextFriday.month);
    });
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDateInRange(DateTime date) {
    if (_startDate == null || _endDate == null) return false;
    return date.isAfter(_startDate!) && date.isBefore(_endDate!);
  }

  int get _nightsCount {
    if (_startDate == null) return 0;
    final end = _endDate ?? _startDate!.add(const Duration(days: 1));
    return end.difference(_startDate!).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final monthYearFormat = DateFormat('MMMM yyyy');
    final canGoPrev = _displayedMonth.isAfter(DateTime(_today.year, _today.month));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TOP TEAL HEADER
              Container(
                padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryTeal, Color(0xFF0092A2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Stay Dates',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _startDate != null
                                    ? dateFormat.format(_startDate!)
                                    : 'Select Check-in',
                                style: const TextStyle(
                                  color: AppColors.mintHighlight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text('  →  ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text(
                                _endDate != null
                                    ? dateFormat.format(_endDate!)
                                    : (_startDate != null ? 'Select Check-out' : 'Check-out'),
                                style: const TextStyle(
                                  color: AppColors.mintHighlight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_nightsCount > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$_nightsCount nt${_nightsCount > 1 ? 's' : ''}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),

              // 2. QUICK PRESET CHIPS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.lightBackground,
                  border: Border(bottom: BorderSide(color: AppColors.lightBorder)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const Text(
                        'QUICK PRESETS:',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      PresetChip(
                        label: 'Tonight (1 Nt)',
                        isSelected: _isSameDay(_startDate, _today) && _nightsCount == 1,
                        onTap: () => _applyPreset(1),
                      ),
                      const SizedBox(width: 6),
                      PresetChip(
                        label: '2 Nights',
                        isSelected: _isSameDay(_startDate, _today) && _nightsCount == 2,
                        onTap: () => _applyPreset(2),
                      ),
                      const SizedBox(width: 6),
                      PresetChip(
                        label: '3 Nights',
                        isSelected: _isSameDay(_startDate, _today) && _nightsCount == 3,
                        onTap: () => _applyPreset(3),
                      ),
                      const SizedBox(width: 6),
                      PresetChip(
                        label: '1 Week',
                        isSelected: _isSameDay(_startDate, _today) && _nightsCount == 7,
                        onTap: () => _applyPreset(7),
                      ),
                      const SizedBox(width: 6),
                      PresetChip(
                        label: 'Weekend',
                        isSelected: false,
                        onTap: _applyWeekendPreset,
                      ),
                    ],
                  ),
                ),
              ),

              // 3. CALENDAR MONTH NAVIGATION
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      color: canGoPrev ? AppColors.primaryTeal : AppColors.textDisabled,
                      onPressed: canGoPrev
                          ? () {
                              setState(() {
                                _displayedMonth = DateTime(
                                  _displayedMonth.year,
                                  _displayedMonth.month - 1,
                                );
                              });
                            }
                          : null,
                    ),
                    Text(
                      monthYearFormat.format(_displayedMonth),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      color: AppColors.primaryTeal,
                      onPressed: () {
                        setState(() {
                          _displayedMonth = DateTime(
                            _displayedMonth.year,
                            _displayedMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),

              // 4. DAY OF WEEK HEADERS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 6),

              // 5. CALENDAR DAYS GRID
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildMonthCalendarGrid(_displayedMonth),
              ),

              const SizedBox(height: 12),

              // 6. BOTTOM ACTION FOOTER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.lightBackground,
                  border: Border(top: BorderSide(color: AppColors.lightBorder)),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _startDate = _today;
                          _endDate = _today.add(const Duration(days: 1));
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textMuted,
                      ),
                      child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textBody,
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _startDate != null
                          ? () {
                              final end = _endDate ?? _startDate!.add(const Duration(days: 1));
                              Navigator.of(context).pop(DateTimeRange(start: _startDate!, end: end));
                            }
                          : null,
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Apply Stay Dates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCalendarGrid(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayWeekday = DateTime(month.year, month.month, 1).weekday; // 1 = Mon, 7 = Sun
    final leadingOffset = firstDayWeekday - 1;
    final totalCells = ((leadingOffset + daysInMonth + 6) ~/ 7) * 7;

    return Column(
      children: List.generate(totalCells ~/ 7, (weekIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: List.generate(7, (dayIndex) {
              final cellIndex = weekIndex * 7 + dayIndex;
              final dayNum = cellIndex - leadingOffset + 1;

              if (dayNum < 1 || dayNum > daysInMonth) {
                return const Expanded(child: SizedBox(height: 38));
              }

              final cellDate = DateTime(month.year, month.month, dayNum);
              final isPast = cellDate.isBefore(_today);
              final isToday = _isSameDay(cellDate, _today);
              final isStart = _isSameDay(cellDate, _startDate);
              final isEnd = _isSameDay(cellDate, _endDate);
              final inRange = _isDateInRange(cellDate);

              Color? bgColor;
              BorderRadius? borderRadius;
              Color textColor = AppColors.textDark;
              FontWeight fontWeight = FontWeight.w600;

              if (isPast) {
                textColor = AppColors.textDisabled;
                fontWeight = FontWeight.normal;
              } else if (isStart && isEnd) {
                bgColor = AppColors.primaryTeal;
                textColor = Colors.white;
                borderRadius = BorderRadius.circular(20);
                fontWeight = FontWeight.bold;
              } else if (isStart) {
                bgColor = AppColors.primaryTeal;
                textColor = Colors.white;
                borderRadius = const BorderRadius.horizontal(left: Radius.circular(20));
                fontWeight = FontWeight.bold;
              } else if (isEnd) {
                bgColor = AppColors.primaryTeal;
                textColor = Colors.white;
                borderRadius = const BorderRadius.horizontal(right: Radius.circular(20));
                fontWeight = FontWeight.bold;
              } else if (inRange) {
                bgColor = AppColors.mintHighlight;
                textColor = const Color(0xFF0F766E);
                fontWeight = FontWeight.w700;
              }

              return Expanded(
                child: InkWell(
                  onTap: isPast ? null : () => _onDateTapped(cellDate),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: borderRadius,
                      border: isToday && !isStart && !isEnd && !inRange
                          ? Border.all(color: AppColors.primaryTeal, width: 1.5)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: textColor,
                        fontWeight: fontWeight,
                        decoration: isPast ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textDisabled,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class PresetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PresetChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textBody,
          ),
        ),
      ),
    );
  }
}
