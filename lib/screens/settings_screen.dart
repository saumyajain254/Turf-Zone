import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _handlePersonalDetails(BuildContext context) {
    final p = Provider.of<AppProvider>(context, listen: false);
    final nameCtrl = TextEditingController(text: p.userName);
    final emailCtrl = TextEditingController(text: p.userEmail);
    final phoneCtrl = TextEditingController(text: p.userPhone);
    final addrCtrl = TextEditingController(text: p.userAddress);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppAdaptive.cardBg(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Details', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            const SizedBox(height: 20),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.mail_outline))),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined))),
            const SizedBox(height: 12),
            TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.home_outlined))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final email = emailCtrl.text.trim();
                  final phone = phoneCtrl.text.trim();
                  final addr = addrCtrl.text.trim();
                  await p.updateProfile(name: name, email: email, handle: p.userHandle, phone: phone, address: addr);
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Details saved!')));
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ).then((_) {
      nameCtrl.dispose();
      emailCtrl.dispose();
      phoneCtrl.dispose();
      addrCtrl.dispose();
    });
  }

  void _handleChangePassword(BuildContext context) {
    final p = Provider.of<AppProvider>(context, listen: false);
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscure = true;
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) => AlertDialog(
          backgroundColor: AppAdaptive.cardBg(context),
          title: Text('Change Password', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Current password', prefixIcon: Icon(Icons.lock_outline)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: newCtrl,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    hintText: 'New password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setS(() => obscure = !obscure)),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Confirm new password', prefixIcon: Icon(Icons.lock_outline)),
                  validator: (v) => v != newCtrl.text ? 'Passwords do not match' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final current = currentCtrl.text;
                final newPwd = newCtrl.text;
                final nav = Navigator.of(ctx);
                final messenger = ScaffoldMessenger.of(context);
                final ok = await p.changePassword(current, newPwd);
                nav.pop();
                messenger.showSnackBar(SnackBar(content: Text(ok ? 'Password changed!' : 'Incorrect current password')));
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    ).then((_) {
      currentCtrl.dispose();
      newCtrl.dispose();
      confirmCtrl.dispose();
    });
  }

  void _handleSavedPayments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppAdaptive.cardBg(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saved Payments', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            const SizedBox(height: 24),
            Center(
              child: Column(children: [
                Icon(Icons.credit_card_off_outlined, size: 48, color: AppAdaptive.textMuted(context)),
                const SizedBox(height: 12),
                Text('No saved payment methods', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 14)),
                const SizedBox(height: 4),
                Text('Add a UPI ID or card for faster checkout', style: TextStyle(color: AppAdaptive.textMuted(context), fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adding payment methods coming soon')));
                },
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: const Text('Add Payment Method', style: TextStyle(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _handleLanguage(BuildContext context) {
    final p = Provider.of<AppProvider>(context, listen: false);
    final langs = ['English (India)', 'हिंदी (Hindi)', 'ગુજરાતી (Gujarati)', 'मराठी (Marathi)', 'தமிழ் (Tamil)'];
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) => AlertDialog(
          backgroundColor: AppAdaptive.cardBg(context),
          title: Text('Select Language', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: langs.map((lang) {
              final isSelected = p.selectedLanguage == lang;
              return GestureDetector(
                onTap: () { p.setLanguage(lang); setS(() {}); },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? AppColors.primary : AppAdaptive.border(context), width: 2),
                      ),
                      child: isSelected
                          ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)))
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      lang,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : (AppAdaptive.isDark(context) ? Colors.white : Colors.black87),
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ]),
                ),
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language set to ${p.selectedLanguage}')));
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleHelpFAQ(BuildContext context) {
    final faqs = [
      {'q': 'How do I book a turf?', 'a': 'Tap any turf card on the Home screen → select your date, time, sport and duration → confirm slot → pay.'},
      {'q': 'Can I cancel my booking?', 'a': 'Cancellations made 24 hours before your slot are fully refunded. Within 24 hours, a 50% cancellation fee applies.'},
      {'q': 'What payment methods are accepted?', 'a': 'We accept UPI (GPay, PhonePe, Paytm), Credit/Debit cards, and Cash on arrival.'},
      {'q': 'How do I use a promo code?', 'a': 'On the Payment screen, enter your promo code in the "Enter promo code" field and tap APPLY.'},
      {'q': 'What is Find Players?', 'a': 'Find Players lets you discover live matches near you, follow other players, and join open challenges.'},
      {'q': 'How do I change my location?', 'a': 'Tap the location name at the top-left of the Home screen. You can search for any city or use GPS.'},
    ];
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(ctx).iconTheme.color), onPressed: () => Navigator.pop(ctx)),
          title: Text('Help & FAQ', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: faqs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final faq = faqs[i];
            return Theme(
              data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                backgroundColor: AppAdaptive.surface(ctx),
                collapsedBackgroundColor: AppAdaptive.surface(ctx),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: const Icon(Icons.help_outline, color: AppColors.primary, size: 20),
                title: Text(faq['q']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppAdaptive.isDark(ctx) ? Colors.white : Colors.black87)),
                iconColor: AppColors.primary,
                collapsedIconColor: AppAdaptive.textHint(ctx),
                children: [Text(faq['a']!, style: TextStyle(color: AppAdaptive.textSecondary(ctx), fontSize: 13, height: 1.5))],
              ),
            );
          },
        ),
      ),
    ));
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppAdaptive.cardBg(context),
        title: Text('Logout', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
        content: Text('Are you sure you want to logout?', style: TextStyle(color: AppAdaptive.textSecondary(context))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color), onPressed: () => Navigator.pop(context)),
        title: Text('SETTINGS', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserCard(context, p),
            const SizedBox(height: 32),
            Text('ACCOUNT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
            const SizedBox(height: 12),
            _buildGroup([
              _item(context, Icons.person_outline, 'Personal Details', 'Name, phone, address', Colors.green, onTap: () => _handlePersonalDetails(context)),
              _item(context, Icons.lock_outline, 'Change Password', 'Update credentials', Colors.blue, onTap: () => _handleChangePassword(context)),
              _item(context, Icons.credit_card_outlined, 'Saved Payments', 'UPI, cards, wallets', Colors.amber, onTap: () => _handleSavedPayments(context), showDivider: false),
            ], context),
            const SizedBox(height: 32),
            Text('PREFERENCES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
            const SizedBox(height: 12),
            _buildGroup([
              _toggle(context, Icons.notifications_none, 'Push Notifications', 'Bookings, offers, reminders', Colors.purple, p.pushNotifications, (v) => p.togglePushNotifications(v)),
              _toggle(context, Icons.dark_mode_outlined, 'Dark Mode', p.isDarkMode ? 'Currently enabled' : 'Currently disabled', Colors.blue, p.isDarkMode, (v) => p.toggleTheme(v)),
              _toggle(context, Icons.location_on_outlined, 'Location Access', 'Show nearby turfs', Colors.green, p.locationAccess, (v) => p.toggleLocationAccess(v)),
              _item(context, Icons.language_outlined, 'Language', p.selectedLanguage, Colors.grey, trailing: '›', onTap: () => _handleLanguage(context)),
              _toggle(context, Icons.shield_outlined, 'Email Notifications', 'Booking confirmations', Colors.blueGrey, p.emailNotifications, (v) => p.toggleEmailNotifications(v), showDivider: false),
            ], context),
            const SizedBox(height: 32),
            Text('SUPPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
            const SizedBox(height: 12),
            _buildGroup([
              _item(context, Icons.help_outline, 'Help & FAQ', '', Colors.blue, onTap: () => _handleHelpFAQ(context)),
              _item(context, Icons.logout, 'Logout', '', Colors.red, showDivider: false, onTap: () => _handleLogout(context)),
            ], context),
            const SizedBox(height: 32),
            Text('ABOUT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
            const SizedBox(height: 12),
            _buildGroup([
              _item(context, Icons.info_outline, 'App Version', '1.2.0 (build 3)', Colors.teal, onTap: null),
              _item(context, Icons.share_outlined, 'Share App', 'Invite friends to Turf Zone', Colors.purple, onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sharing coming soon')))),
              _item(context, Icons.star_outline, 'Rate Us', 'Enjoying the app? Leave a review', Colors.amber, onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rating coming soon')))),
              _item(context, Icons.privacy_tip_outlined, 'Privacy Policy', '', Colors.blueGrey, showDivider: false, onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy policy coming soon')))),
            ], context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, AppProvider p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppAdaptive.cardBg(context), borderRadius: BorderRadius.circular(16),
          boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Row(children: [
        CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: Text(p.userInitials, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
          Text(p.userEmail.isNotEmpty ? p.userEmail : p.userHandle, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
        ])),
        Icon(Icons.chevron_right, color: AppAdaptive.textMuted(context)),
      ]),
    );
  }

  Widget _buildGroup(List<Widget> children, BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppAdaptive.cardBg(context), borderRadius: BorderRadius.circular(16),
          boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Column(children: children),
    );
  }

  Widget _item(BuildContext context, IconData icon, String title, String subtitle, Color iconColor, {String? trailing, bool showDivider = true, VoidCallback? onTap}) {
    return Column(children: [
      ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withAlpha(26), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 11)) : null,
        trailing: trailing != null ? Text(trailing, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 16)) : Icon(Icons.chevron_right, color: AppAdaptive.textMuted(context), size: 18),
        onTap: onTap,
      ),
      if (showDivider) Divider(color: AppAdaptive.divider(context), height: 1, indent: 60),
    ]);
  }

  Widget _toggle(BuildContext context, IconData icon, String title, String subtitle, Color iconColor, bool value, Function(bool) onChanged, {bool showDivider = true}) {
    return Column(children: [
      ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withAlpha(26), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
        subtitle: Text(subtitle, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 11)),
        trailing: Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary, activeTrackColor: AppColors.primary.withAlpha(100)),
      ),
      if (showDivider) Divider(color: AppAdaptive.divider(context), height: 1, indent: 60),
    ]);
  }
}
