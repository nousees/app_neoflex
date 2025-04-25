import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class TechTapGame extends StatefulWidget {
  @override
  _TechTapGameState createState() => _TechTapGameState();
}

class _TechTapGameState extends State<TechTapGame> {
  List<Map<String, dynamic>> icons = [];
  int score = 0;
  bool isGameActive = false;
  int timeLeft = 30;
  Timer? timer;
  List<Timer> iconTimers = [];
  int currentCombo = 0;
  int missedIcons = 0;
  bool isPerfectGame = true;
  int _selectedIndex = 1;
  final double iconSize = 50.0;
  final double minY = 80.0;
  double bottomPadding = 80.0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      icons.clear();
      score = 0;
      timeLeft = 30;
      isGameActive = true;
      currentCombo = 0;
      missedIcons = 0;
      isPerfectGame = true;
    });
    
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          endGame();
        } else {
          spawnIcon();
        }
      });
    });
  }

  void spawnIcon() {
    if (currentCombo > 0) {
      setState(() {
        missedIcons++;
        isPerfectGame = false;
        currentCombo = 0;
      });
    }
    
    final random = Random();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double maxX = screenWidth - iconSize;
    final double maxY = screenHeight - iconSize - bottomPadding;
    final double x = random.nextDouble() * maxX;
    final double y = minY + random.nextDouble() * (maxY - minY);

    final icon = {
      'x': x,
      'y': y,
      'type': ['AI', 'Cloud', 'Blockchain'][random.nextInt(3)],
      'value': random.nextInt(5) + 1,
    };
    
    if (!mounted) return;
    setState(() {
      icons.add(icon);
      if (icons.length > 10) icons.removeAt(0);
    });
    
    final iconTimer = Timer(Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => icons.remove(icon));
    });
    iconTimers.add(iconTimer);
  }

  void tapIcon(Map<String, dynamic> icon) {
    if (!isGameActive) return;
    
    setState(() {
      score += icon['value'] as int;
      icons.remove(icon);
      currentCombo++;
      
      if (currentCombo > Provider.of<GameState>(context, listen: false).maxTechTapCombo) {
        Provider.of<GameState>(context, listen: false).maxTechTapCombo = currentCombo;
      }
      
      if (currentCombo >= 10) {
        Provider.of<GameState>(context, listen: false).unlockBadge('combo_master');
      }
    });
  }

  void endGame() {
    timer?.cancel();
    iconTimers.forEach((t) => t.cancel());
    iconTimers.clear();
    
    final gameState = Provider.of<GameState>(context, listen: false);
    
    if (isPerfectGame && missedIcons == 0) {
      gameState.techTapPerfectGames++;
      if (gameState.techTapPerfectGames >= 5) {
        gameState.unlockBadge('perfect_tapper');
      }
    }
    
    if (score >= 50) gameState.unlockBadge('tech_master');
    if (score >= 100) gameState.unlockBadge('speedster');
    
    gameState.addCoins(score);
    gameState.addGameScore('Tech Tap', score);
    
    setState(() => isGameActive = false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Игра окончена!'),
        content: Text('Вы заработали $score NeoCoins'),
        actions: [
          TextButton(
            child: Text('Играть снова'),
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
          ),
          TextButton(
            child: Text('В меню'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/games');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/leaderboard');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    iconTimers.forEach((t) => t.cancel());
    iconTimers.clear();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (isGameActive) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Выйти из игры?'),
          content: Text('Ваш прогресс будет сохранён.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Нет', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                timer?.cancel();
                iconTimers.forEach((t) => t.cancel());
                iconTimers.clear();
                Provider.of<GameState>(context, listen: false).addCoins(score);
                Provider.of<GameState>(context, listen: false).addGameScore('Tech Tap', score);
                Navigator.pop(context, true);
              },
              child: Text('Да', style: TextStyle(color: Color(0xFFFF6200))),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tech Tap'),
          backgroundColor: Color(0xFF6200EA),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6200EA), Color(0xFFFF6200)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Осталось времени: $timeLeft сек | Очки: $score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              ...icons.map((icon) => Positioned(
                    left: icon['x'],
                    top: icon['y'],
                    child: GestureDetector(
                      onTap: () => tapIcon(icon),
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF6200),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/${icon['type'].toLowerCase()}.png',
                            width: iconSize * 0.8,
                            height: iconSize * 0.8,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                icon['type'],
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
            BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Игры'),
            BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Рейтинг'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFFFF6200),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}