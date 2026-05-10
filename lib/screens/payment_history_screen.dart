import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _filter = 'All';

  static const _all = [
    {'name': 'Arena 5-a-Side', 'details': 'FOOTBALL • 1HR • 9AM', 'date': 'Apr 10, 2026', 'method': 'UPI • GPay', 'amount': '₹800', 'fee': '+ ₹20 fee', 'status': 'PAID'},
    {'name': 'Thunder Box Cricket', 'details': 'CRICKET • 2HR • 8PM', 'date': 'Apr 7, 2026', 'method': 'Card • HDFC', 'amount': '₹2,400', 'fee': '+ ₹40 fee', 'status': 'PAID'},
    {'name': 'Court Pro Badminton', 'details': 'BADMINTON • 1HR • 7PM', 'date': 'Apr 3, 2026', 'method': 'UPI • PhonePe', 'amount': '₹500', 'fee': 'Refunded', 'status': 'REFUNDED'},
    {'name': 'Arena 5-a-Side', 'details': 'FOOTBALL • 2HR • 6PM', 'date': 'Mar 29, 2026', 'method': 'Pay at Venue', 'amount': '₹1,600', 'fee': 'Pending', 'status': 'PENDING'},
    {'name': 'SportsPlex Indoor', 'details': 'BASKETBALL • 1HR • 8PM', 'date': 'Mar 22, 2026', 'method': 'Card • ICICI', 'amount': '₹1,000', 'fee': 'Failed', 'status': 'FAILED'},
  ];

  List<Map<String, String>> get _filtered => _filter == 'All'
      ? List<Map<String, String>>.from(_all)
      : _all.where((h) => h['status'] == _filter.toUpperCase()).map((h) => Map<String, String>.from(h)).toList();

  Color _statusColor(String s) {
    switch (s) {
      case 'PAID': return AppColors.primary;
      case 'REFUNDED': return Colors.blue;
      case 'PENDING': return Colors.amber;
      case 'FAILED': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color), onPressed: () => Navigator.pop(context)),
        title: Text('PAYMENT HISTORY', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStats(context),
            const SizedBox(height: 24),
            _buildFilters(context),
            const SizedBox(height: 24),
            if (_filtered.isEmpty)
              Center(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('No transactions found', style: TextStyle(color: AppAdaptive.textHint(context))),
              ))
            else
              ..._filtered.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildItem(context, h['name']!, h['details']!, h['date']!, h['method']!, h['amount']!, h['fee']!, h['status']!, _statusColor(h['status']!)),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Column(children: [
      Row(children: [
        _stat(context, 'TOTAL SPENT', '₹28,400', AppColors.primary),
        const SizedBox(width: 12),
        _stat(context, 'TRANSACTIONS', '38', AppAdaptive.isDark(context) ? Colors.white : Colors.black87),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        _stat(context, 'THIS MONTH', '₹4,200', Colors.amber),
        const SizedBox(width: 12),
        _stat(context, 'SAVED', '₹1,200', AppAdaptive.isDark(context) ? Colors.blue : AppColors.primary),
      ]),
    ]);
  }

  Widget _stat(BuildContext context, String label, String value, Color valueColor) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppAdaptive.isDark(context) ? AppAdaptive.surface(context) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    ));
  }

  Widget _buildFilters(BuildContext context) {
    const filters = ['All', 'Paid', 'Pending', 'Refunded', 'Failed'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = f == _filter;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (_) => setState(() => _filter = f),
              backgroundColor: AppAdaptive.chipUnselected(context),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.black : AppAdaptive.textSecondary(context), fontSize: 12, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String name, String details, String date, String method, String amount, String fee, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppAdaptive.cardBg(context), borderRadius: BorderRadius.circular(20),
          boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            const SizedBox(height: 4),
            Text(details, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 9, fontWeight: FontWeight.bold)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            Text(fee, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 9)),
          ]),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(date, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 11)),
            Text(method, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withAlpha(77)),
            ),
            child: Row(children: [
              Icon(status == 'PAID' ? Icons.check : status == 'PENDING' ? Icons.access_time : status == 'REFUNDED' ? Icons.refresh : Icons.close, color: statusColor, size: 10),
              const SizedBox(width: 4),
              Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ]),
          ),
        ]),
      ]),
    );
  }
}
