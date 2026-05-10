import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/select_slot_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/payment_history_screen.dart';
import 'screens/find_players_screen.dart';
import 'providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: TurfZoneApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class TurfZoneApp extends StatelessWidget {
  final bool isLoggedIn;
  const TurfZoneApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'Turf Zone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: isLoggedIn ? '/home' : '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/select_slot') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => SelectSlotScreen(
              turfName: args?['name'] ?? 'Arena 5-a-Side',
              location: args?['location'] ?? 'Ring Road, Vadodara',
              price: args?['price'] ?? '₹800/hr',
            ),
          );
        }
        if (settings.name == '/payment') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => PaymentScreen(
              turfName: args?['turfName'] ?? 'Arena 5-a-Side',
              location: args?['location'] ?? 'Ring Road, Vadodara',
              price: args?['price'] ?? '₹800/hr',
              sport: args?['sport'] ?? 'Football',
              date: args?['date'] ?? 'Apr 20',
              timeSlot: args?['timeSlot'] ?? '9:00 AM',
              duration: args?['duration'] ?? 1,
            ),
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/favourites': (context) => const FavouritesScreen(),
        '/payment_history': (context) => const PaymentHistoryScreen(),
        '/find_players': (context) => const FindPlayersScreen(),
      },
    );
  }
}
