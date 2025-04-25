import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/games_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/tech_tap_game.dart';
import 'screens/code_match_game.dart';
import 'screens/shop_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/badges_screen.dart';
import 'screens/history_screen.dart';
import 'screens/quiz_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: NeoChallengeApp(),
    ),
  );
}

class NeoChallengeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeoChallenge',
      theme: ThemeData(
        primaryColor: Color(0xFF6200EA),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF6200EA),
          secondary: Color(0xFFFF6200),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          headlineSmall: TextStyle(color: Color(0xFF6200EA), fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6200),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/games': (context) => GamesScreen(),
        '/profile': (context) => ProfileScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
        '/tech_tap': (context) => TechTapGame(),
        '/code_match': (context) => CodeMatchGame(),
        '/shop': (context) => ShopScreen(),
        '/rewards': (context) => RewardsScreen(),
        '/badges': (context) => BadgesScreen(),
        '/history': (context) => HistoryScreen(),
        '/quiz': (context) => QuizScreen(),
      },
    );
  }
}