import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final favs = appProvider.favourites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('FAVOURITES', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: false,
      ),
      body: favs.isEmpty
          ? Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.favorite_border, size: 64, color: AppAdaptive.textMuted(context)),
                const SizedBox(height: 16),
                Text('No favourites yet', style: TextStyle(color: AppAdaptive.textHint(context))),
                const SizedBox(height: 8),
                Text('Heart a turf on the home screen to save it here.',
                    style: TextStyle(color: AppAdaptive.textMuted(context), fontSize: 12)),
              ]),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final turf = favs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppAdaptive.cardBg(context),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppAdaptive.isDark(context) ? null : [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Row(children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: AppAdaptive.isDark(context) ? AppColors.primary.withAlpha(26) : const Color(0xFFD4EDDA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.sports_soccer, color: AppColors.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(turf.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
                        Text(turf.location, style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(turf.rating, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(width: 12),
                          Text(turf.price.split('/')[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ]),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/select_slot', arguments: {'name': turf.name, 'location': turf.location, 'price': turf.price}),
                          child: const Text('Book Now →', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ])),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => appProvider.toggleFavourite(turf),
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
