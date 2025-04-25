import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showRewardNotification = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final gameState = Provider.of<GameState>(context, listen: false);
      await gameState.handleDailyLogin();
      setState(() {
        _showRewardNotification = true;
      });
    });
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

  void _navigateToQuiz(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    if (gameState.hasCompletedQuiz && gameState.quizProgress == 10) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Тест уже пройден!'),
          content: Text('Вы уже ответили на 10/10 вопросов. Точно ли хотите пройти ещё раз?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/quiz');
              },
              child: Text('Пройти снова'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushNamed(context, '/quiz');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NeoChallenge'),
        backgroundColor: Color(0xFF6200EA),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6200EA), Color(0xFFFF6200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<GameState>(
          builder: (context, state, _) {
            if (_showRewardNotification && state.loginStreak > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final rewards = [10, 15, 20, 25, 30, 35, 50];
                int reward;
                if (state.loginStreak <= 7) {
                  reward = rewards[state.loginStreak - 1];
                } else {
                  reward = 5;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Вы получили $reward NeoCoins за вход!'),
                    backgroundColor: Colors.green,
                  ),
                );
              });
              _showRewardNotification = false;
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Добро пожаловать!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text('Ваш баланс'),
                      subtitle: Text('NeoCoins: ${state.neoCoins} | Серия входов: ${state.loginStreak}'),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  Text(
                    'Доступные опции',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Посетить магазин'),
                      trailing: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/shop'),
                        child: Text('В магазин'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Награды за вход'),
                      trailing: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/rewards'),
                        child: Text('Посмотреть'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('История компании'),
                      trailing: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/history'),
                        child: Text('Посмотреть'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Тест по истории Neoflex'),
                      trailing: ElevatedButton(
                        onPressed: () => _navigateToQuiz(context),
                        child: Text(state.hasCompletedQuiz ? 'Пройти снова' : 'Пройти'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
    );
  }
}