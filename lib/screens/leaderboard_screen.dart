import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedIndex = 2;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рейтинг'),
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
          builder: (context, state, _) => Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Лучшие результаты',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tech Tap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: state.techTapScores.isEmpty
                      ? Center(
                          child: Text(
                            'Нет результатов',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.techTapScores.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Text('#${index + 1}', style: TextStyle(color: Color(0xFFFF6200))),
                                title: Text('${state.techTapScores[index]} очков'),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 16),
                Text(
                  'Code Match',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: state.codeMatchScores.isEmpty
                      ? Center(
                          child: Text(
                            'Нет результатов',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.codeMatchScores.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Text('#${index + 1}', style: TextStyle(color: Color(0xFFFF6200))),
                                title: Text('${state.codeMatchScores[index]} очков'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
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