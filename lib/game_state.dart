import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/badge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameState with ChangeNotifier {
  static final GameState _instance = GameState._internal();

  factory GameState() {
    return _instance;
  }

  GameState._internal() {
    _initialize();
  }

  int neoCoins = 0;
  List<String> purchasedItems = [];
  int loginStreak = 0;
  DateTime? lastLoginDate;
  List<String> activityLog = [];
  List<int> techTapScores = [];
  List<int> codeMatchScores = [];
  int gamesPlayed = 0;
  int perfectCodeMatchRuns = 0;
  bool usedHintInCodeMatch = false;
  int maxTechTapCombo = 0;
  int techTapPerfectGames = 0;
  bool hasCompletedQuiz = false;
  int quizProgress = 0;
  bool hasHandledDailyLogin = false;
  bool _isInitialized = false;

  int lessonsCompleted = 0;
  int miniQuizzesCompleted = 0;
  List<String> completedLessons = [];

  List<Badge> allBadges = [
    Badge(
      id: 'memory_novice',
      title: 'Новичок памяти',
      description: 'Пройдите 1 уровень в Code Match',
      icon: 'assets/badges/memory.png',
      game: 'Code Match',
    ),
    Badge(
      id: 'pair_master',
      title: 'Мастер пар',
      description: 'Пройдите 2 уровень в Code Match',
      icon: 'assets/badges/pair.png',
      game: 'Code Match',
    ),
    Badge(
      id: 'code_genius',
      title: 'Гений кода',
      description: 'Пройдите 3 уровень в Code Match',
      icon: 'assets/badges/genius.png',
      game: 'Code Match',
    ),
    Badge(
      id: 'memory_legend',
      title: 'Легенда памяти',
      description: 'Пройти все уровни Code Match без ошибок и подсказок',
      icon: 'assets/badges/memory_legend.png',
      game: 'Code Match',
    ),
    Badge(
      id: 'flawless',
      title: 'Безупречный',
      description: 'Пройдите уровень Code Match без ошибок',
      icon: 'assets/badges/flawless.png',
      game: 'Code Match',
    ),
    Badge(
      id: 'tech_master',
      title: 'Мастер технологий',
      description: 'Набрать 50 очков в Tech Tap',
      icon: 'assets/badges/tech.png',
      game: 'Tech Tap',
      requiredScore: 50,
    ),
    Badge(
      id: 'speedster',
      title: 'Скорострел',
      description: 'Набрать 100 очков в Tech Tap',
      icon: 'assets/badges/speedster.png',
      game: 'Tech Tap',
      requiredScore: 100,
    ),
    Badge(
      id: 'combo_master',
      title: 'Мастер комбо',
      description: 'Собрать 10 иконок подряд в Tech Tap',
      icon: 'assets/badges/combo_master.png',
      game: 'Tech Tap',
    ),
    Badge(
      id: 'perfect_tapper',
      title: 'Идеальный тапер',
      description: '5 идеальных игр в Tech Tap (без пропущенных иконок)',
      icon: 'assets/badges/perfect_tapper.png',
      game: 'Tech Tap',
    ),
    Badge(
      id: 'veteran',
      title: 'Ветеран',
      description: 'Сыграть 50 игр',
      icon: 'assets/badges/veteran.png',
      requiredGames: 50,
    ),
    Badge(
      id: 'collector',
      title: 'Коллекционер',
      description: 'Купить все предметы в магазине',
      icon: 'assets/badges/collector.png',
    ),
    Badge(
      id: 'week_starter',
      title: 'Начинатель недели',
      description: 'Входить в приложение 7 дней подряд',
      icon: 'assets/badges/week.png',
      requiredDays: 7,
    ),
    Badge(
      id: 'loyal_player',
      title: 'Верный игрок',
      description: 'Входить в приложение 30 дней подряд',
      icon: 'assets/badges/loyal.png',
      requiredDays: 30,
    ),
    Badge(
      id: 'history_expert',
      title: 'Эксперт по истории',
      description: 'Пройдите тест по истории компании Neoflex',
      icon: 'assets/badges/history_expert.png',
      game: 'Quiz',
    ),
    Badge(
      id: 'education_novice',
      title: 'Новичок образования',
      description: 'Пройдите 1 урок в образовательном блоке',
      icon: 'assets/badges/education_novice.png',
      game: 'Education',
    ),
    Badge(
      id: 'quiz_master',
      title: 'Мастер тестов',
      description: 'Пройдите 3 мини-теста в образовательном блоке',
      icon: 'assets/badges/quiz_master.png',
      game: 'Education',
    ),
    Badge(
      id: 'achievement_master',
      title: 'Мастер достижений',
      description: 'Соберите все остальные достижения',
      icon: 'assets/badges/achievement_master.png',
    ),
  ];

  Future<void> _initialize() async {
    await _loadState();
    await handleDailyLogin();
    _isInitialized = true;
  }

  List<String> get getActivityLog => activityLog;
  List<String> get getPurchasedItems => purchasedItems;
  List<Badge> get unlockedBadges => allBadges.where((b) => b.isUnlocked).toList();

  void addCoins(int coins) {
    neoCoins += coins;
    _saveState();
    notifyListeners();
  }

  void completeLesson(String lessonTitle) {
    if (!completedLessons.contains(lessonTitle)) {
      lessonsCompleted++;
      completedLessons.add(lessonTitle);
      activityLog.insert(0, 'Пройден урок в образовательном блоке: $lessonTitle');
      if (lessonsCompleted >= 1) {
        unlockBadge('education_novice');
      }
      _saveState();
      notifyListeners();
    }
  }

  bool isLessonCompleted(String lessonTitle) {
    return completedLessons.contains(lessonTitle);
  }

  void completeMiniQuiz() {
    miniQuizzesCompleted++;
    activityLog.insert(0, 'Пройден мини-тест в образовательном блоке');
    if (miniQuizzesCompleted >= 3) {
      unlockBadge('quiz_master');
    }
    _saveState();
    notifyListeners();
  }

  void unlockBadge(String id) async {
    final user = Supabase.instance.client.auth.currentUser;
    final badgeIndex = allBadges.indexWhere((b) => b.id == id);
    if (badgeIndex != -1 && !allBadges[badgeIndex].isUnlocked && user != null) {
      allBadges[badgeIndex] = allBadges[badgeIndex].copyWith(isUnlocked: true);
      activityLog.insert(0, 'Получен бейдж: ${allBadges[badgeIndex].title}');
      _checkAchievementMaster();
      await Supabase.instance.client
          .from('user_badges')
          .insert({'user_id': user.id, 'badge_id': id});
      notifyListeners();
    }
  }

  void _checkAchievementMaster() {
    final totalBadgesExcludingMaster = allBadges.where((badge) => badge.id != 'achievement_master').length;
    final unlockedBadgesExcludingMaster = allBadges.where((badge) => badge.id != 'achievement_master' && badge.isUnlocked).length;

    if (unlockedBadgesExcludingMaster == totalBadgesExcludingMaster) {
      unlockBadge('achievement_master');
    }
  }

  void completeQuiz(int correctAnswers) {
    hasCompletedQuiz = true;
    quizProgress = correctAnswers;
    if (correctAnswers >= 8 && !allBadges.any((badge) => badge.id == 'history_expert' && badge.isUnlocked)) {
      unlockBadge('history_expert');
    }
    _saveState();
    notifyListeners();
  }

  void purchaseItem(String item, int cost) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (neoCoins >= cost && !purchasedItems.contains(item) && user != null) {
      neoCoins -= cost;
      purchasedItems.add(item);
      activityLog.insert(0, 'Куплен предмет: $item за $cost NeoCoins');
      checkCollectorBadge();
      await Supabase.instance.client
          .from('profiles')
          .update({'neo_coins': neoCoins})
          .eq('id', user.id);
      await Supabase.instance.client
          .from('user_purchases')
          .insert({'user_id': user.id, 'item_name': item});
      notifyListeners();
    }
  }

  Future<void> handleDailyLogin() async {
    if (hasHandledDailyLogin) {
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final user = Supabase.instance.client.auth.currentUser;

    if (lastLoginDate == null) {
      loginStreak = 1;
      neoCoins += 10;
      lastLoginDate = today;
      hasHandledDailyLogin = true;
    } else {
      final lastLoginDay = DateTime(lastLoginDate!.year, lastLoginDate!.month, lastLoginDate!.day);

      if (lastLoginDay == today) {
        hasHandledDailyLogin = true;
        return;
      }

      final yesterday = today.subtract(Duration(days: 1));

      if (lastLoginDay == yesterday) {
        loginStreak++;
      } else {
        loginStreak = 1;
      }

      int reward = 5;
      if (loginStreak <= 7) {
        final rewards = [10, 15, 20, 25, 30, 35, 50];
        reward = rewards[loginStreak - 1];
      }

      neoCoins += reward;
      activityLog.insert(0, 'Награда за вход: $reward NeoCoins (день $loginStreak)');

      for (var badge in allBadges) {
        if (!badge.isUnlocked && badge.requiredDays != null && loginStreak >= badge.requiredDays!) {
          unlockBadge(badge.id);
        }
      }

      lastLoginDate = today;
      hasHandledDailyLogin = true;
    }

    await _saveState();
    notifyListeners();
  }

  void addGameScore(String game, int score) {
    if (game == 'Tech Tap') {
      techTapScores.add(score);
      techTapScores.sort((a, b) => b.compareTo(a));
      if (techTapScores.length > 5) techTapScores.removeLast();
    } else if (game == 'Code Match') {
      codeMatchScores.add(score);
      codeMatchScores.sort((a, b) => b.compareTo(a));
      if (codeMatchScores.length > 5) codeMatchScores.removeLast();
    }

    activityLog.insert(0, 'Сыграна игра $game: $score очков');
    incrementGamesPlayed();
    _saveState();
    notifyListeners();
  }

  void incrementGamesPlayed() {
    gamesPlayed++;
    checkVeteranBadge();
    _saveState();
  }

  void checkVeteranBadge() {
    if (gamesPlayed >= 50) {
      unlockBadge('veteran');
    }
  }

  void checkCollectorBadge() {
    const allItems = [
      'Powerbank', 'Термокружка', 'Бутылка',
      'Портативная колонка', 'Музыкальная станция',
      'Блокнот и ручка (набор 1)', 'Блокнот и ручка (набор 2)'
    ];

    if (allItems.every((item) => purchasedItems.contains(item))) {
      unlockBadge('collector');
    }
  }

  void checkMemoryLegendBadge() {
    if (perfectCodeMatchRuns >= 3 && !usedHintInCodeMatch) {
      unlockBadge('memory_legend');
    }
  }

  Future<void> _loadState() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final profile = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    neoCoins = profile['neo_coins'] ?? 0;
    loginStreak = profile['login_streak'] ?? 0;
    lastLoginDate = profile['last_login_date'] != null
        ? DateTime.parse(profile['last_login_date'])
        : null;

    // Загрузка покупок
    final purchases = await Supabase.instance.client
        .from('user_purchases')
        .select('item_name')
        .eq('user_id', user.id);
    purchasedItems = purchases.map<String>((e) => e['item_name'] as String).toList();

    // Загрузка бейджей
    final badges = await Supabase.instance.client
        .from('user_badges')
        .select('badge_id')
        .eq('user_id', user.id);
    final unlockedBadgeIds = badges.map<String>((e) => e['badge_id'] as String).toList();
    allBadges = allBadges.map((badge) {
      return badge.copyWith(isUnlocked: unlockedBadgeIds.contains(badge.id));
    }).toList();

    notifyListeners();
  }

  Future<void> _saveState() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    await Supabase.instance.client
        .from('profiles')
        .update({
          'neo_coins': neoCoins,
          'login_streak': loginStreak,
          'last_login_date': lastLoginDate?.toIso8601String(),
        })
        .eq('id', user.id);
    // Покупки и бейджи сохраняются сразу при изменении, отдельного сохранения не требуют
  }
}