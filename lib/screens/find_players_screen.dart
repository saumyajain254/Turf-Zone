import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FindPlayersScreen extends StatefulWidget {
  const FindPlayersScreen({super.key});

  @override
  State<FindPlayersScreen> createState() => _FindPlayersScreenState();
}

class _FindPlayersScreenState extends State<FindPlayersScreen> {
  final List<bool> _following = [true, false, false, false, true, false];
  String _searchQuery = '';

  static final List<Map<String, dynamic>> _players = [
    {'name': 'Arjun K.', 'sport': 'Football', 'rating': '4.8', 'color': Colors.green, 'initials': 'AK'},
    {'name': 'Priya M.', 'sport': 'Badminton', 'rating': '4.5', 'color': Colors.purple, 'initials': 'PM'},
    {'name': 'Rohit S.', 'sport': 'Cricket', 'rating': '4.9', 'color': Colors.amber, 'initials': 'RS'},
    {'name': 'Neha P.', 'sport': 'Football', 'rating': '4.6', 'color': Colors.blue, 'initials': 'NP'},
    {'name': 'Vikas R.', 'sport': 'Basketball', 'rating': '4.3', 'color': Colors.greenAccent, 'initials': 'VR'},
    {'name': 'Sara K.', 'sport': 'Cricket', 'rating': '4.7', 'color': Colors.pink, 'initials': 'SK'},
  ];

  List<int> get _filteredIdx {
    if (_searchQuery.isEmpty) return List.generate(_players.length, (i) => i);
    return List.generate(_players.length, (i) => i).where((i) {
      final p = _players[i];
      return (p['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (p['sport'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _nav(BuildContext context, int index) {
    switch (index) {
      case 0: Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false); break;
      case 1: Navigator.pushNamed(context, '/payment_history'); break;
      case 2: Navigator.pushNamed(context, '/favourites'); break;
      case 3: Navigator.pushNamed(context, '/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSearch(context),
            const SizedBox(height: 32),
            _buildLiveMatches(context),
            const SizedBox(height: 32),
            _buildPlayers(context),
            const SizedBox(height: 32),
            _buildChallenges(context),
          ]),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('COMMUNITY', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('FIND PLAYERS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1.2, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.red.withAlpha(26), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withAlpha(77))),
          child: const Row(children: [CircleAvatar(backgroundColor: Colors.red, radius: 3), SizedBox(width: 6), Text('3 LIVE', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))]),
        ),
      ]),
    ]);
  }

  Widget _buildSearch(BuildContext context) {
    return TextField(
      onChanged: (v) => setState(() => _searchQuery = v),
      decoration: InputDecoration(
        hintText: 'Search players or sport...',
        prefixIcon: Icon(Icons.search, color: AppAdaptive.textHint(context)),
        fillColor: AppAdaptive.surface(context),
        filled: true,
      ),
    );
  }

  Widget _buildLiveMatches(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          const CircleAvatar(backgroundColor: Colors.red, radius: 4),
          const SizedBox(width: 8),
          Text('LIVE MATCHES NEARBY', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        ]),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more live matches nearby'))),
          child: const Text('See all \u2192', style: TextStyle(color: AppColors.primary, fontSize: 11)),
        ),
      ]),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppAdaptive.liveMatchBg(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppAdaptive.liveMatchBorder(context)),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Row(children: [Icon(Icons.sports_soccer, color: Colors.red, size: 12), SizedBox(width: 4), Text('FOOTBALL • 5-A-SIDE', style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold))]),
            Text('Live • 34 min', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 9)),
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _teamInfo('Alpha FC', Icons.bolt, Colors.orange),
            Column(children: [
              Text('2 - 1', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
              Text('2nd Half', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10)),
            ]),
            _teamInfo('Blue Wave', Icons.waves, Colors.blue),
          ]),
          const SizedBox(height: 20),
          Divider(color: AppAdaptive.divider(context)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [Icon(Icons.location_on, size: 12, color: AppAdaptive.textHint(context)), const SizedBox(width: 4), Text('Arena 5-a-Side', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 10))]),
            const Text('2 spots open', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppAdaptive.cardBg(context),
                  title: Text('Join as Substitute', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
                  content: Text('Request sent to Alpha FC!\nYou\'ll be notified if accepted.', style: TextStyle(color: AppAdaptive.textSecondary(context))),
                  actions: [ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppAdaptive.joinButtonBg(context),
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.bolt, size: 16), SizedBox(width: 8), Text('Join as Substitute', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _teamInfo(String name, IconData icon, Color color) {
    return Column(children: [
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: color.withAlpha(26), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(height: 8),
      Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
    ]);
  }

  Widget _buildPlayers(BuildContext context) {
    final idxs = _filteredIdx;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          const Icon(Icons.people, color: Colors.deepPurpleAccent, size: 18),
          const SizedBox(width: 8),
          Text('PLAYERS NEAR YOU', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        ]),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Showing all nearby players'))),
          child: const Text('View all \u2192', style: TextStyle(color: AppColors.primary, fontSize: 11)),
        ),
      ]),
      const SizedBox(height: 16),
      if (idxs.isEmpty)
        Center(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text('No players found', style: TextStyle(color: AppAdaptive.textHint(context))),
        ))
      else
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.75),
          itemCount: idxs.length,
          itemBuilder: (context, i) {
            final idx = idxs[i];
            final player = _players[idx];
            final isFollowing = _following[idx];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppAdaptive.cardBg(context), borderRadius: BorderRadius.circular(16),
                  boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)]),
              child: Column(children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: (player['color'] as Color).withAlpha(51),
                  child: Text(player['initials'] as String, style: TextStyle(color: player['color'] as Color, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(height: 8),
                Text(player['name'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87), textAlign: TextAlign.center, maxLines: 1),
                Text(player['sport'] as String, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 9)),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star, color: Colors.amber, size: 8),
                  const SizedBox(width: 2),
                  Text(player['rating'] as String, style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() => _following[idx] = !isFollowing),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isFollowing ? Colors.green.withAlpha(26) : AppAdaptive.surface(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isFollowing ? Colors.green.withAlpha(77) : Colors.transparent),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if (isFollowing) const Icon(Icons.check, color: Colors.green, size: 10),
                      const SizedBox(width: 4),
                      Text(isFollowing ? 'Following' : '+ Follow',
                          style: TextStyle(color: isFollowing ? Colors.green : AppAdaptive.textSecondary(context), fontSize: 9, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ]),
            );
          },
        ),
    ]);
  }

  Widget _buildChallenges(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
        const SizedBox(width: 8),
        Text('OPEN CHALLENGES', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      ]),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppAdaptive.cardBg(context),
            title: Text('Weekend Cricket Thrill', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
            content: Text('6 players joined • 4 spots left\n\nDate: Sunday, Apr 27\nVenue: Thunder Box Cricket\nFormat: T10', style: TextStyle(color: AppAdaptive.textSecondary(context))),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined Weekend Cricket Thrill!')));
                },
                child: const Text('Join Challenge'),
              ),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppAdaptive.cardBg(context), borderRadius: BorderRadius.circular(20),
              boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6, offset: const Offset(0, 2))]),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: Colors.amber.withAlpha(26), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.sports_cricket, color: Colors.amber),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Weekend Cricket Thrill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
              Text('6 players joined • 4 spots left', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 11)),
            ])),
            Icon(Icons.chevron_right, color: AppAdaptive.textMuted(context)),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppAdaptive.navBg(context),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppAdaptive.navUnselected(context),
      showUnselectedLabels: true,
      currentIndex: 0,
      onTap: (index) => _nav(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
    );
  }
}
