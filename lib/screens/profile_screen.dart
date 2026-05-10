import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Set<String> _selectedSports = {'Football', 'Cricket', 'Badminton'};

  void _showEditProfile(BuildContext context) {
    final p = Provider.of<AppProvider>(context, listen: false);
    final nameCtrl = TextEditingController(text: p.userName);
    final handleCtrl = TextEditingController(text: p.userHandle);
    final phoneCtrl = TextEditingController(text: p.userPhone);
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
            Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            const SizedBox(height: 20),
            TextField(controller: nameCtrl, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 12),
            TextField(controller: handleCtrl, decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.alternate_email))),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
                prefixText: '+91 ',
                counterText: '',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final handle = handleCtrl.text.trim();
                  final phone = phoneCtrl.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
                    return;
                  }
                  if (phone.isNotEmpty && phone.length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid 10-digit phone number')));
                    return;
                  }
                  await p.updateProfile(name: name, email: p.userEmail, handle: handle, phone: phone, address: p.userAddress);
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    setState(() {});
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
      handleCtrl.dispose();
      phoneCtrl.dispose();
    });
  }

  void _showEditCover(BuildContext context) {
    final gradients = [
      [const Color(0xFF00E676), const Color(0xFF1A1A1A)],
      [Colors.blue, const Color(0xFF0A0A2E)],
      [Colors.purple, const Color(0xFF1A0A2E)],
      [Colors.orange, const Color(0xFF2E1A0A)],
      [Colors.red, const Color(0xFF2E0A0A)],
      [Colors.teal, const Color(0xFF0A2E2E)],
    ];
    int selected = 0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) => AlertDialog(
          backgroundColor: AppAdaptive.cardBg(context),
          title: Text('Choose Cover Style', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          content: Wrap(
            spacing: 12, runSpacing: 12,
            children: List.generate(gradients.length, (i) => GestureDetector(
              onTap: () => setS(() => selected = i),
              child: Container(
                width: 70, height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradients[i]),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: selected == i ? AppColors.primary : Colors.transparent, width: 2),
                ),
                child: selected == i ? const Center(child: Icon(Icons.check, color: Colors.white, size: 16)) : null,
              ),
            )),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cover updated!')));
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, appProvider),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(context),
                  const SizedBox(height: 32),
                  Text('CONTACT INFO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
                  const SizedBox(height: 12),
                  _buildContactCard(context, appProvider),
                  const SizedBox(height: 32),
                  Text('FAVOURITE SPORTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
                  const SizedBox(height: 12),
                  _buildFavouriteSports(context),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RECENT ACTIVITY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/payment_history'),
                        child: const Text('View all', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildEmptyActivity(context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AppProvider p) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppAdaptive.isDark(context)
                  ? [AppColors.primary.withAlpha(51), Theme.of(context).scaffoldBackgroundColor]
                  : [const Color(0xFF1A6B35), const Color(0xFF2D9E54)],
              begin: AppAdaptive.isDark(context) ? Alignment.topCenter : Alignment.topLeft,
              end: AppAdaptive.isDark(context) ? Alignment.bottomCenter : Alignment.bottomRight,
            ),
          ),
          child: CustomPaint(painter: _HeaderPainter()),
        ),
        Positioned(
          top: 40, right: 20,
          child: OutlinedButton(
            onPressed: () => _showEditCover(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: AppAdaptive.isDark(context) ? AppAdaptive.border(context) : Colors.white54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
            ),
            child: const Row(children: [Icon(Icons.edit, size: 12), SizedBox(width: 4), Text('Edit Cover', style: TextStyle(fontSize: 10))]),
          ),
        ),
        Positioned(
          bottom: 0, left: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child: Text(p.userInitials, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(p.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                    const SizedBox(width: 8),
                    _buildTag('Verified', AppColors.primary, Icons.check_circle_outline),
                  ]),
                  Text(
                    p.userHandle.isNotEmpty ? p.userHandle : '@user',
                    style: TextStyle(color: AppAdaptive.isDark(context) ? AppAdaptive.textHint(context) : Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    _buildTag('Player', Colors.blue, Icons.sports_soccer),
                  ]),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 100, right: 20,
          child: OutlinedButton(
            onPressed: () => _showEditProfile(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: AppAdaptive.isDark(context) ? AppAdaptive.border(context) : Colors.white54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
            ),
            child: const Row(children: [Icon(Icons.edit, size: 12), SizedBox(width: 4), Text('Edit Profile', style: TextStyle(fontSize: 10))]),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withAlpha(77))),
      child: Row(children: [
        Icon(icon, color: color, size: 10),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(context, '0', 'BOOKINGS'),
        _buildStatItem(context, '0', 'VENUES'),
        _buildStatItem(context, '₹0', 'SPENT', valueColor: AppColors.primary),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, {Color? valueColor}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppAdaptive.isDark(context) ? AppAdaptive.surface(context) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: valueColor ?? (AppAdaptive.isDark(context) ? Colors.white : Colors.black87))),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: AppAdaptive.textHint(context), fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, AppProvider p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppAdaptive.isDark(context) ? AppAdaptive.surface(context) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        _buildContactRow(context, Icons.mail_outline, 'Email', p.userEmail.isNotEmpty ? p.userEmail : 'Not set', Colors.green),
        Divider(color: AppAdaptive.divider(context), height: 24),
        _buildContactRow(context, Icons.phone_outlined, 'Phone', p.userPhone.isNotEmpty ? '+91 ${p.userPhone}' : 'Not set', Colors.blue),
        Divider(color: AppAdaptive.divider(context), height: 24),
        _buildContactRow(context, Icons.location_on_outlined, 'Location', p.userAddress.isNotEmpty ? p.userAddress : 'Not set', Colors.orange),
      ]),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String label, String value, Color iconColor) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withAlpha(26), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10)),
        Text(value, style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    ]);
  }

  Widget _buildFavouriteSports(BuildContext context) {
    final sports = [
      {'name': 'Football', 'icon': Icons.sports_soccer},
      {'name': 'Cricket', 'icon': Icons.sports_cricket},
      {'name': 'Badminton', 'icon': Icons.sports_tennis},
      {'name': 'Basketball', 'icon': Icons.sports_basketball},
    ];
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: sports.map((sport) {
        final name = sport['name'] as String;
        final isSelected = _selectedSports.contains(name);
        return GestureDetector(
          onTap: () => setState(() => isSelected ? _selectedSports.remove(name) : _selectedSports.add(name)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withAlpha(26) : AppAdaptive.surface(context),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(sport['icon'] as IconData, size: 14, color: isSelected ? AppColors.primary : AppAdaptive.textSecondary(context)),
              const SizedBox(width: 8),
              Text(name, style: TextStyle(fontSize: 12, color: isSelected ? AppColors.primary : AppAdaptive.textSecondary(context), fontWeight: FontWeight.bold)),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyActivity(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(color: AppAdaptive.surface(context), borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Column(children: [
          Icon(Icons.sports_soccer, size: 40, color: AppAdaptive.textMuted(context)),
          const SizedBox(height: 12),
          Text('No bookings yet', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Your past bookings will appear here', style: TextStyle(color: AppAdaptive.textMuted(context), fontSize: 11)),
        ]),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppAdaptive.navBg(context),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppAdaptive.navUnselected(context),
      showUnselectedLabels: true,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0: Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false); break;
          case 1: Navigator.pushNamed(context, '/payment_history'); break;
          case 2: Navigator.pushNamed(context, '/favourites'); break;
          case 3: Navigator.pushNamed(context, '/settings'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
    );
  }
}

class _HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withAlpha(13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), i * 40.0, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
