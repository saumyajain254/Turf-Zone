import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/turf_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All Sports';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  static final List<Turf> _allTurfs = [
    Turf(id: '1', name: 'Arena 5-a-Side', location: 'Ring Road, Vadodara', rating: '4.3', price: '₹800/hr', tags: ['FOOTBALL', 'CRICKET', 'OUTDOOR'], isOpen: true, imagePath: 'assets/turf_1.jpg'),
    Turf(id: '2', name: 'Thunder Box Cricket', location: 'Alkapuri, Vadodara', rating: '4.8', price: '₹1200/hr', tags: ['CRICKET', 'FOOTBALL', 'OUTDOOR'], isOpen: true, imagePath: 'assets/turf_2.jpg'),
    Turf(id: '3', name: 'Court Pro Badminton', location: 'Gotri, Vadodara', rating: '4.6', price: '₹500/hr', tags: ['BADMINTON', 'INDOOR'], isOpen: true, imagePath: 'assets/turf_3.jpg'),
    Turf(id: '4', name: 'SportsPlex Indoor', location: 'Manjalpur, Vadodara', rating: '4.2', price: '₹1000/hr', tags: ['BASKETBALL', 'BADMINTON', 'INDOOR'], isOpen: false, imagePath: 'assets/turf_4.jpg'),
  ];

  static const List<String> _cities = [
    'Mumbai, Maharashtra', 'Delhi, Delhi', 'Bengaluru, Karnataka',
    'Hyderabad, Telangana', 'Chennai, Tamil Nadu', 'Kolkata, West Bengal',
    'Ahmedabad, Gujarat', 'Pune, Maharashtra', 'Surat, Gujarat',
    'Vadodara, Gujarat', 'Jaipur, Rajasthan',
    'Lucknow, Uttar Pradesh', 'Kanpur, Uttar Pradesh', 'Nagpur, Maharashtra',
    'Indore, Madhya Pradesh', 'Bhopal, Madhya Pradesh', 'Patna, Bihar',
    'Ludhiana, Punjab', 'Agra, Uttar Pradesh', 'Nashik, Maharashtra',
    'Rajkot, Gujarat', 'Varanasi, Uttar Pradesh', 'Aurangabad, Maharashtra',
    'Amritsar, Punjab', 'Coimbatore, Tamil Nadu', 'Guwahati, Assam',
    'Chandigarh, Punjab', 'Mysore, Karnataka', 'Kochi, Kerala',
    'Bhubaneswar, Odisha', 'Thiruvananthapuram, Kerala', 'Goa, Goa',
    'Noida, Uttar Pradesh', 'Gurgaon, Haryana', 'Faridabad, Haryana',
    'Ranchi, Jharkhand', 'Meerut, Uttar Pradesh', 'Visakhapatnam, Andhra Pradesh',
  ];

  List<Turf> get _filteredTurfs {
    return _allTurfs.where((turf) {
      final matchesSearch = _searchQuery.isEmpty ||
          turf.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          turf.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All Sports' ||
          turf.tags.any((t) => t.toLowerCase().contains(_selectedCategory.toLowerCase()));
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showLocationPicker(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    String searchCity = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppAdaptive.cardBg(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) {
          final filtered = _cities.where((c) => c.toLowerCase().contains(searchCity.toLowerCase())).toList();
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx2).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(ctx2).size.height * 0.65,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: AppAdaptive.divider(ctx2), borderRadius: BorderRadius.circular(2))),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choose Location', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppAdaptive.isDark(ctx2) ? Colors.white : Colors.black87)),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            appProvider.refreshLocation();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withAlpha(77)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.my_location, color: AppColors.primary, size: 20),
                                SizedBox(width: 12),
                                Text('Use current GPS location', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          autofocus: true,
                          onChanged: (v) => setS(() => searchCity = v),
                          decoration: InputDecoration(
                            hintText: 'Search city...',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            fillColor: AppAdaptive.surface(ctx2),
                            filled: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                        title: Text(filtered[i], style: TextStyle(color: AppAdaptive.isDark(ctx2) ? Colors.white : Colors.black87, fontSize: 14)),
                        onTap: () {
                          appProvider.updateCityName(filtered[i]);
                          Navigator.pop(ctx);
                        },
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildBanner(context),
                const SizedBox(height: 24),
                _buildSearchBar(context),
                const SizedBox(height: 24),
                _buildCategories(context),
                const SizedBox(height: 32),
                _buildNearbyTurfsHeader(context),
                const SizedBox(height: 16),
                if (_filteredTurfs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 48, color: AppAdaptive.textMuted(context)),
                          const SizedBox(height: 12),
                          Text('No turfs found', style: TextStyle(color: AppAdaptive.textHint(context), fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Try a different search or category', style: TextStyle(color: AppAdaptive.textMuted(context), fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                else
                  ..._filteredTurfs.map((turf) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildTurfCard(context, turf),
                      )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cityName = Provider.of<AppProvider>(context).cityName;
    final initials = Provider.of<AppProvider>(context).userInitials;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _showLocationPicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
              Row(
                children: [
                  Text(cityName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications'))),
              child: Icon(Icons.notifications_none, color: AppAdaptive.iconMuted(context)),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 18,
                child: Text(initials, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppAdaptive.bannerGradientStart(context), AppAdaptive.bannerGradientEnd(context)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppAdaptive.bannerBorderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppAdaptive.bannerPillBg(context), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(backgroundColor: AppAdaptive.bannerPillFg(context), radius: 3),
                const SizedBox(width: 4),
                Text('NOW ACCEPTING BOOKINGS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppAdaptive.bannerPillFg(context))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('BOOK YOUR', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: AppAdaptive.bannerTitleColor(context))),
          Text('TURF', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = AppAdaptive.isDark(context);
    return Container(
      decoration: isDark
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(18), blurRadius: 8, offset: const Offset(0, 2))],
            ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Search turf, area or location...',
          prefixIcon: Icon(Icons.search, color: AppAdaptive.textHint(context)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppAdaptive.textHint(context), size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          fillColor: isDark ? AppAdaptive.surface(context) : Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    const categories = ['All Sports', 'Football', 'Cricket', 'Badminton', 'Basketball'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == _selectedCategory;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = cat),
              backgroundColor: AppAdaptive.chipUnselected(context),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.black : AppAdaptive.textSecondary(context), fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNearbyTurfsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('NEARBY TURFS', style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: AppAdaptive.isDark(context) ? null : const Color(0xFF111111),
        )),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/find_players'),
          child: const Text('Community →', style: TextStyle(color: AppColors.primary, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildTurfCard(BuildContext context, Turf turf) {
    final appProvider = Provider.of<AppProvider>(context);
    final isFav = appProvider.isFavourite(turf);
    return InkWell(
      onTap: turf.isOpen
          ? () => Navigator.pushNamed(context, '/select_slot', arguments: {'name': turf.name, 'location': turf.location, 'price': turf.price})
          : () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This turf is currently closed'))),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: AppAdaptive.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: turf.imagePath != null
                      ? Image.asset(
                          turf.imagePath!,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _turfImagePlaceholder(context, turf),
                        )
                      : _turfImagePlaceholder(context, turf),
                ),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: turf.isOpen ? AppColors.primary : Colors.red, radius: 3),
                        const SizedBox(width: 4),
                        Text(turf.isOpen ? 'OPEN' : 'CLOSED', style: TextStyle(fontSize: 10, color: turf.isOpen ? AppColors.primary : Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: GestureDetector(
                    onTap: () => appProvider.toggleFavourite(turf),
                    child: CircleAvatar(
                      backgroundColor: Colors.black54, radius: 14,
                      child: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 16, color: isFav ? Colors.red : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(turf.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.amber.withAlpha(51), borderRadius: BorderRadius.circular(4)),
                        child: Row(children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(turf.rating, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 10)),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(turf.location, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
                  ]),
                  const SizedBox(height: 12),
                  Row(
                    children: turf.tags.map((tag) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppAdaptive.tagBg(context), borderRadius: BorderRadius.circular(4)),
                      child: Text(tag, style: TextStyle(fontSize: 9, color: AppAdaptive.tagText(context), fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: turf.price.split('/')[0],
                          style: TextStyle(color: turf.isOpen ? AppAdaptive.primaryAdaptive(context) : AppAdaptive.textHint(context), fontWeight: FontWeight.w800, fontSize: 18),
                          children: [TextSpan(text: '/hr', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12, fontWeight: FontWeight.normal))],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: turf.isOpen
                            ? () => Navigator.pushNamed(context, '/select_slot', arguments: {'name': turf.name, 'location': turf.location, 'price': turf.price})
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          backgroundColor: turf.isOpen ? AppAdaptive.viewDetailsActiveBg(context) : Colors.transparent,
                          side: turf.isOpen ? AppAdaptive.viewDetailsActiveSide(context) : BorderSide(color: AppAdaptive.border(context)),
                          disabledBackgroundColor: Colors.transparent,
                        ),
                        child: Row(children: [
                          Text('View Details', style: TextStyle(color: turf.isOpen ? AppAdaptive.viewDetailsActiveText(context) : AppAdaptive.textMuted(context), fontSize: 12)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 12, color: turf.isOpen ? AppAdaptive.viewDetailsActiveText(context) : AppAdaptive.textMuted(context)),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _turfImagePlaceholder(BuildContext context, Turf turf) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: turf.isOpen
              ? [AppColors.primary.withAlpha(77), AppAdaptive.surface(context)]
              : [Colors.grey.withAlpha(77), AppAdaptive.surface(context)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(child: Icon(Icons.star_outline, size: 60, color: turf.isOpen ? AppColors.primary.withAlpha(51) : Colors.grey.withAlpha(51))),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final isDark = AppAdaptive.isDark(context);
    final nav = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppAdaptive.navBg(context),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppAdaptive.navUnselected(context),
      showUnselectedLabels: true,
      currentIndex: 0,
      elevation: isDark ? 8 : 0,
      onTap: (index) => _navigateTo(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
    );
    if (isDark) return nav;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: nav,
    );
  }
}
