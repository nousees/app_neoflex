import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class CodeMatchGame extends StatefulWidget {
  const CodeMatchGame({Key? key}) : super(key: key);

  @override
  _CodeMatchGameState createState() => _CodeMatchGameState();
}

class _CodeMatchGameState extends State<CodeMatchGame> with SingleTickerProviderStateMixin {
  int currentLevel = 1;
  int moves = 0;
  int score = 0;
  Map<String, dynamic>? firstCard;
  bool isProcessing = false;
  List<Map<String, dynamic>> cards = [];
  bool canUseHint = true;
  bool hadMistake = false;
  
  final Map<String, String> pairs = {
    'AI': 'Машинное обучение',
    'Cloud': 'Облачные вычисления',
    'Blockchain': 'Распределённый реестр',
    'Big Data': 'Анализ больших данных',
  };
  
  final List<Map<String, dynamic>> levelConfig = [
    {'pairs': 2, 'moveLimit': 4, 'coinsPerPair': 5, 'badgeId': 'memory_novice'},
    {'pairs': 3, 'moveLimit': 6, 'coinsPerPair': 6, 'badgeId': 'pair_master'},
    {'pairs': 4, 'moveLimit': 8, 'coinsPerPair': 7, 'badgeId': 'code_genius'},
  ];

  int _selectedIndex = 1;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );
    startLevel();
  }

  void startLevel() {
    final config = levelConfig[currentLevel - 1];
    final int pairsCount = config['pairs'] as int;
    final List<String> pairKeys = pairs.keys.toList()..shuffle(Random());

    cards = [];
    for (int i = 0; i < pairsCount; i++) {
      final String key = pairKeys[i];
      final String value = pairs[key]!;
      cards.add({
        'id': '${key}_1',
        'value': key,
        'isMatched': false,
        'isFlipped': false,
        'isWrong': false,
      });
      cards.add({
        'id': '${key}_2',
        'value': value,
        'isMatched': false,
        'isFlipped': false,
        'isWrong': false,
      });
    }
    cards.shuffle(Random());

    setState(() {
      moves = 0;
      score = 0;
      hadMistake = false;
      for (var card in cards) {
        card['isFlipped'] = false;
        card['isMatched'] = false;
        card['isWrong'] = false;
      }
      firstCard = null;
      isProcessing = false;
      canUseHint = true;
    });
    
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.usedHintInCodeMatch = false;
  }

  void flipCard(int index) async {
    if (isProcessing || cards[index]['isFlipped'] || cards[index]['isMatched']) return;
    
    setState(() {
      cards[index]['isFlipped'] = true;
    });

    if (firstCard == null) {
      firstCard = cards[index];
    } else {
      setState(() {
        isProcessing = true;
        moves++;
      });

      final config = levelConfig[currentLevel - 1];
      final int moveLimit = config['moveLimit'] as int;
      
      if (moves > moveLimit && !cards.every((card) => card['isMatched'])) {
        _failLevel();
        return;
      }

      final secondCard = cards[index];
      if (pairs[firstCard!['value']] == secondCard['value'] || 
          pairs[secondCard['value']] == firstCard!['value']) {
        setState(() {
          firstCard!['isMatched'] = true;
          secondCard['isMatched'] = true;
          score += config['coinsPerPair'] as int;
          isProcessing = false;
        });
        
        if (cards.every((card) => card['isMatched'])) {
          completeLevel();
        } else {
          firstCard = null;
        }
      } else {
        setState(() {
          hadMistake = true;
          firstCard!['isWrong'] = true;
          secondCard['isWrong'] = true;
        });
        
        _shakeController.forward(from: 0);
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!mounted) return;
        setState(() {
          firstCard!['isFlipped'] = false;
          secondCard['isFlipped'] = false;
          firstCard!['isWrong'] = false;
          secondCard['isWrong'] = false;
          isProcessing = false;
          firstCard = null;
        });
      }
    }
  }

  void useHint() {
    final gameState = Provider.of<GameState>(context, listen: false);
    if (!canUseHint || gameState.neoCoins < 10) return;

    Map<String, dynamic>? hintCard1;
    Map<String, dynamic>? hintCard2;
    
    for (var card in cards) {
      if (!card['isMatched'] && !card['isFlipped'] && pairs.containsKey(card['value'])) {
        hintCard1 = card;
        break;
      }
    }
    
    if (hintCard1 != null) {
      for (var card in cards) {
        if (!card['isMatched'] && !card['isFlipped'] && 
            card != hintCard1 && pairs[hintCard1['value']] == card['value']) {
          hintCard2 = card;
          break;
        }
      }
    }

    if (hintCard1 != null && hintCard2 != null) {
      gameState.addCoins(-10);
      gameState.usedHintInCodeMatch = true;
      
      setState(() {
        hintCard1!['isFlipped'] = true;
        hintCard2!['isFlipped'] = true;
        hintCard1!['isMatched'] = true;
        hintCard2!['isMatched'] = true;
        score += levelConfig[currentLevel - 1]['coinsPerPair'] as int;
        canUseHint = false;
      });
      
      if (cards.every((card) => card['isMatched'])) {
        completeLevel();
      }
    }
  }

  void completeLevel() {
    final config = levelConfig[currentLevel - 1];
    final gameState = Provider.of<GameState>(context, listen: false);
    final int idealMoves = config['pairs'] as int;
    final int moveLimit = config['moveLimit'] as int;
    
    double bonusMultiplier = 1.0;
    if (moves == idealMoves) {
      bonusMultiplier = 2.0;
    } else if (moves <= (moveLimit / 2)) {
      bonusMultiplier = 1.5;
    }
    
    final int finalScore = (score * bonusMultiplier).round();
    gameState.addCoins(finalScore);
    
    if (moves <= moveLimit) {
      gameState.unlockBadge(config['badgeId'] as String);
      
      // Проверка бейджей
      if (!hadMistake) {
        gameState.unlockBadge('flawless');
        gameState.perfectCodeMatchRuns++;
        
        if (!gameState.usedHintInCodeMatch) {
          gameState.checkMemoryLegendBadge();
        }
      }
    }

    gameState.addGameScore('Code Match', finalScore);

    if (currentLevel < levelConfig.length) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Уровень $currentLevel завершён!'),
          content: Text('Вы заработали $finalScore NeoCoins'),
          actions: [
            TextButton(
              child: Text('Следующий уровень'),
              onPressed: () {
                Navigator.pop(context);
                setState(() => currentLevel++);
                startLevel();
              },
            ),
            TextButton(
              child: Text('В меню'),
              onPressed: () => Navigator.pushReplacementNamed(context, '/games'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Игра пройдена!'),
          content: Text('Вы прошли все уровни!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pushReplacementNamed(context, '/games'),
            ),
          ],
        ),
      );
    }
  }

  void _failLevel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Неудача!'),
        content: Text('Вы превысили лимит ходов. Попробуйте снова.'),
        actions: [
          TextButton(
            child: Text('Повторить'),
            onPressed: () {
              Navigator.pop(context);
              startLevel();
            },
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
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalPairs = levelConfig[currentLevel - 1]['pairs'] as int;
    final int matchedPairs = cards.where((card) => card['isMatched']).length ~/ 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Code Match - Уровень $currentLevel'),
        backgroundColor: Color(0xFF6200EA),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    'Перезапустить уровень?',
                    style: TextStyle(color: Color(0xFF6200EA)),
                  ),
                  content: Text(
                    'Вы потеряете текущий прогресс. Продолжить?',
                    style: TextStyle(color: Colors.black87),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Отмена',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        startLevel();
                      },
                      child: Text(
                        'Перезапустить',
                        style: TextStyle(color: Color(0xFFFF6200)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.lightbulb, color: canUseHint ? Colors.white : Colors.grey),
            onPressed: canUseHint ? useHint : null,
            tooltip: 'Подсказка (-10 NeoCoins)',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6200EA), Color(0xFFFF6200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Найдено пар: $matchedPairs/$totalPairs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: matchedPairs / totalPairs,
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6200)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: cards.length <= 4 ? 2 : 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: cards.asMap().entries.map((entry) {
                    final index = entry.key;
                    final card = entry.value;
                    return GestureDetector(
                      onTap: () => flipCard(index),
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: card['isWrong']
                                ? Offset(_shakeAnimation.value, 0)
                                : Offset(0, 0),
                            child: child,
                          );
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: card['isMatched']
                                ? Color(0xFF4CAF50)
                                : card['isWrong']
                                    ? Color(0xFFF44336)
                                    : card['isFlipped']
                                        ? Color(0xFFFF6200)
                                        : Color(0xFF9575CD),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: card['isFlipped'] || card['isMatched'] ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 300),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  card['value'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Ходы: $moves/${levelConfig[currentLevel - 1]['moveLimit']} | Счёт: $score',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6200EA),
              ),
            ),
          ),
          BottomNavigationBar(
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
        ],
      ),
    );
  }
}