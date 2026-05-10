import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final String turfName;
  final String location;
  final String price;
  final String sport;
  final String date;
  final String timeSlot;
  final int duration;

  const PaymentScreen({
    super.key,
    this.turfName = 'Arena 5-a-Side',
    this.location = 'Ring Road, Vadodara',
    this.price = '₹800/hr',
    this.sport = 'Football',
    this.date = 'Apr 20',
    this.timeSlot = '9:00 AM',
    this.duration = 1,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'UPI';
  final _promoCtrl = TextEditingController();
  int _discount = 0;
  bool _promoApplied = false;
  bool _isLoading = false;
  static const int _fee = 20;
  static const Map<String, int> _codes = {'TURF10': 10, 'SAVE20': 20};

  int get _base {
    final raw = widget.price.replaceAll('₹', '').split('/')[0].trim();
    return (int.tryParse(raw) ?? 800) * widget.duration;
  }

  int get _discountAmt => (_base * _discount / 100).round();
  int get _total => _base + _fee - _discountAmt;

  @override
  void dispose() { _promoCtrl.dispose(); super.dispose(); }

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (_codes.containsKey(code)) {
      setState(() { _discount = _codes[code]!; _promoApplied = true; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Promo applied: $_discount% off!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid promo code')));
    }
  }

  void _handlePay() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppAdaptive.cardBg(context),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 20),
            Text('Booking Confirmed!', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(widget.turfName, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${widget.date} • ${widget.timeSlot}', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
            const SizedBox(height: 4),
            Text('${widget.sport} • ${widget.duration}h', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
            const SizedBox(height: 20),
            Text('₹$_total paid via $_selectedMethod', style: TextStyle(color: AppAdaptive.textSecondary(context), fontSize: 12)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color), onPressed: () => Navigator.pop(context)),
        title: Text('PAYMENT', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummary(context),
            const SizedBox(height: 32),
            Text('PAYMENT METHOD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
            const SizedBox(height: 16),
            _buildMethods(context),
            const SizedBox(height: 24),
            _buildPromo(context),
            const SizedBox(height: 32),
            _buildTotal(context),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handlePay,
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.payment, size: 18),
                        const SizedBox(width: 8),
                        Text('PAY ₹$_total'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ]),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.lock_outline, size: 12, color: AppAdaptive.textHint(context)),
              const SizedBox(width: 4),
              Text('256-bit SSL secured payment', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10)),
            ])),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(26)),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.sports_soccer, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.turfName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            Text(widget.location, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 11)),
          ])),
        ]),
        const SizedBox(height: 20),
        Divider(color: AppAdaptive.divider(context)),
        const SizedBox(height: 12),
        _row(context, 'Date', widget.date),
        _row(context, 'Time Slot', widget.timeSlot),
        _row(context, 'Sport', widget.sport),
        _row(context, 'Duration', '${widget.duration} Hour${widget.duration > 1 ? "s" : ""}'),
        const SizedBox(height: 12),
        Divider(color: AppAdaptive.divider(context)),
        const SizedBox(height: 12),
        _row(context, 'Base Price', '₹$_base'),
        _row(context, 'Convenience Fee', '₹$_fee'),
        if (_discount > 0) _row(context, 'Discount ($_discount%)', '- ₹$_discountAmt', valueColor: AppColors.primary),
      ]),
    );
  }

  Widget _row(BuildContext context, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 13)),
        Text(value, style: TextStyle(color: valueColor ?? (AppAdaptive.isDark(context) ? Colors.white : Colors.black87), fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
    );
  }

  Widget _buildMethods(BuildContext context) {
    return Column(children: [
      _method(context, 'UPI / GPay / PhonePe', 'Instant transfer', 'UPI'),
      const SizedBox(height: 12),
      _method(context, 'Credit / Debit Card', 'Visa, Mastercard, RuPay', 'CARD'),
      const SizedBox(height: 12),
      _method(context, 'Pay at Venue', 'Cash on arrival', 'CASH'),
    ]);
  }

  Widget _method(BuildContext context, String title, String subtitle, String code) {
    final isSelected = _selectedMethod == code;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = code),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppAdaptive.surface(context),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? AppColors.primary : AppAdaptive.border(context), width: 2)),
            child: isSelected ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))) : null,
          ),
          const SizedBox(width: 16),
          Container(
            width: 32, height: 32, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppAdaptive.divider(context), borderRadius: BorderRadius.circular(6)),
            child: Text(code, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            Text(subtitle, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10)),
          ])),
        ]),
      ),
    );
  }

  Widget _buildPromo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: AppAdaptive.surface(context), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(Icons.discount_outlined, size: 16, color: AppAdaptive.textHint(context)),
        const SizedBox(width: 12),
        Expanded(child: TextField(
          controller: _promoCtrl,
          enabled: !_promoApplied,
          decoration: InputDecoration(
            hintText: _promoApplied ? 'Promo applied!' : 'Enter promo code',
            hintStyle: TextStyle(fontSize: 13, color: _promoApplied ? AppColors.primary : AppAdaptive.textMuted(context)),
            filled: false, contentPadding: EdgeInsets.zero,
          ),
        )),
        TextButton(
          onPressed: _promoApplied ? null : _applyPromo,
          child: Text(_promoApplied ? 'APPLIED' : 'APPLY',
              style: TextStyle(color: _promoApplied ? AppAdaptive.textHint(context) : AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ]),
    );
  }

  Widget _buildTotal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppAdaptive.surface(context), borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Total Amount', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          Text('Incl. all taxes & fees', style: TextStyle(color: AppAdaptive.textMuted(context), fontSize: 10)),
        ]),
        Text('₹$_total', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24)),
      ]),
    );
  }
}
