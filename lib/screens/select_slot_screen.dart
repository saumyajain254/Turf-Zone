import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SelectSlotScreen extends StatefulWidget {
  final String turfName;
  final String location;
  final String price;

  const SelectSlotScreen({
    super.key,
    this.turfName = 'Arena 5-a-Side',
    this.location = 'Ring Road, Vadodara',
    this.price = '₹800/hr',
  });

  @override
  State<SelectSlotScreen> createState() => _SelectSlotScreenState();
}

class _SelectSlotScreenState extends State<SelectSlotScreen> {
  String _selectedSport = 'Football';
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  String _selectedTime = '9:00 AM';
  int _duration = 1;

  final List<String> _slots = [
    '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
    '6:00 PM', '7:00 PM', '8:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _selectedDate = now;
  }

  int get _pricePerHour {
    final raw = widget.price.replaceAll('₹', '').split('/')[0].trim();
    return int.tryParse(raw) ?? 800;
  }

  int get _totalPrice => _pricePerHour * _duration;

  String get _formattedDate {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[_selectedDate.month - 1]} ${_selectedDate.day}';
  }

  String get _endTime {
    final start = _parseTime(_selectedTime);
    final end = start + Duration(hours: _duration);
    return _formatTime(end);
  }

  Duration _parseTime(String t) {
    final parts = t.split(' ');
    final hm = parts[0].split(':');
    int h = int.parse(hm[0]);
    final m = int.parse(hm[1]);
    if (parts[1] == 'PM' && h != 12) h += 12;
    if (parts[1] == 'AM' && h == 12) h = 0;
    return Duration(hours: h, minutes: m);
  }

  String _formatTime(Duration d) {
    int h = d.inHours % 24;
    final m = d.inMinutes % 60;
    final period = h >= 12 ? 'PM' : 'AM';
    if (h > 12) h -= 12;
    if (h == 0) h = 12;
    return '$h:${m == 0 ? "00" : m.toString().padLeft(2, "0")} $period';
  }

  @override
  Widget build(BuildContext context) {
    // light-mode page background — dark mode inherits theme default (#0F0F0F)
    return Scaffold(
      backgroundColor: AppAdaptive.isDark(context) ? null : const Color(0xFFF4F6F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color), onPressed: () => Navigator.pop(context)),
        title: Text('SELECT SLOT', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTurfSummary(context),
            const SizedBox(height: 32),
            Text('SELECT SPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
            const SizedBox(height: 12),
            _buildSportSelector(context),
            const SizedBox(height: 32),
            _buildCalendarHeader(context),
            const SizedBox(height: 16),
            _buildCalendar(context),
            const SizedBox(height: 32),
            Text('AVAILABLE SLOTS — ${_formattedDate.toUpperCase()}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
            const SizedBox(height: 16),
            _buildTimeSlots(context),
            const SizedBox(height: 32),
            // light mode: wrap footer in white card with top shadow; dark mode: transparent pass-through
            Container(
              decoration: AppAdaptive.isDark(context)
                  ? null
                  : const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, -2))],
                    ),
              child: _buildFooter(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurfSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppAdaptive.surface(context), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.sports_soccer, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.turfName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
          Text(widget.location, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(widget.price.split('/')[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          Text('/hr', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10)),
        ]),
      ]),
    );
  }

  Widget _buildSportSelector(BuildContext context) {
    final sports = [
      {'name': 'Football', 'icon': Icons.sports_soccer},
      {'name': 'Cricket', 'icon': Icons.sports_cricket},
      {'name': 'Badminton', 'icon': Icons.sports_tennis},
    ];
    return Row(
      children: sports.map((sport) {
        final isSelected = sport['name'] == _selectedSport;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedSport = sport['name'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.transparent : AppAdaptive.surface(context),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(sport['icon'] as IconData, size: 14, color: isSelected ? AppColors.primary : AppAdaptive.textSecondary(context)),
                const SizedBox(width: 4),
                Text(sport['name'] as String, style: TextStyle(fontSize: 12, color: isSelected ? AppColors.primary : AppAdaptive.textSecondary(context), fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarHeader(BuildContext context) {
    const months = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];
    final label = '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
    final now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('SELECT DATE — $label', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
        Row(children: [
          GestureDetector(
            onTap: () {
              final prev = DateTime(_currentMonth.year, _currentMonth.month - 1);
              if (!prev.isBefore(DateTime(now.year, now.month))) setState(() => _currentMonth = prev);
            },
            child: Icon(Icons.chevron_left, color: AppAdaptive.textHint(context), size: 20),
          ),
          GestureDetector(
            onTap: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1)),
            child: const Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
          ),
        ]),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;
    final today = DateTime.now();
    final rows = ((startWeekday + daysInMonth) / 7).ceil();
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) => Text(d, style: TextStyle(color: AppAdaptive.textMuted(context), fontSize: 10))).toList(),
      ),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: rows * 7,
        itemBuilder: (context, index) {
          final dayNumber = index - startWeekday + 1;
          if (dayNumber < 1 || dayNumber > daysInMonth) return const SizedBox();
          final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
          final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
          final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
          final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
          return GestureDetector(
            onTap: isPast ? null : () => setState(() => _selectedDate = date),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : isToday ? AppAdaptive.divider(context) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text('$dayNumber', style: TextStyle(
                color: isPast ? AppAdaptive.textVeryMuted(context) : isSelected ? Colors.black : AppAdaptive.isDark(context) ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ))),
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildTimeSlots(BuildContext context) {
    final isDark = AppAdaptive.isDark(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.5, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: _slots.length,
      itemBuilder: (context, index) {
        final isSelected = _slots[index] == _selectedTime;
        return GestureDetector(
          onTap: () => setState(() => _selectedTime = _slots[index]),
          child: Container(
            decoration: BoxDecoration(
              // dark mode: original behaviour (surface bg, primary border when selected)
              // light mode: white/green-tint bg + visible border
              color: isSelected
                  ? (isDark ? Colors.transparent : const Color(0xFFE8F5E9))
                  : (isDark ? AppAdaptive.surface(context) : Colors.white),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.transparent : const Color(0xFFE0E0E0)),
              ),
              borderRadius: BorderRadius.circular(isDark ? 10 : 12),
            ),
            child: Center(child: Text(_slots[index], style: TextStyle(
              color: isSelected ? AppColors.primary : AppAdaptive.textHint(context),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ))),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$_formattedDate • $_selectedTime • ${_duration}h', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10)),
            Text('₹$_totalPrice', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppAdaptive.surface(context), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              GestureDetector(
                onTap: () { if (_duration > 1) setState(() => _duration--); },
                child: Icon(Icons.remove, size: 14, color: _duration > 1 ? AppColors.primary : AppAdaptive.textMuted(context)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${_duration}h', style: TextStyle(fontWeight: FontWeight.bold, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
              ),
              GestureDetector(
                onTap: () { if (_duration < 4) setState(() => _duration++); },
                child: Icon(Icons.add, size: 14, color: _duration < 4 ? AppColors.primary : AppAdaptive.textMuted(context)),
              ),
            ]),
          ),
        ],
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/payment', arguments: {
            'turfName': widget.turfName, 'location': widget.location, 'price': widget.price,
            'sport': _selectedSport, 'date': _formattedDate,
            'timeSlot': '$_selectedTime - $_endTime', 'duration': _duration,
          }),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Confirm Slot'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18)]),
        ),
      ),
    ]);
  }
}
