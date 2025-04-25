import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

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
        title: Text('Личный кабинет'),
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
          builder: (context, state, _) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Профиль',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text('Информация'),
                      subtitle: Text(
                        'NeoCoins: ${state.neoCoins}\n'
                        'Серия входов: ${state.loginStreak} дней\n'
                        'Сыграно игр: ${state.techTapScores.length + state.codeMatchScores.length}',
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text('Бейджи'),
                      subtitle: Text('Получено ${state.unlockedBadges.length} из ${state.allBadges.length}'),
                      trailing: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/badges'),
                        child: Text('Посмотреть все'),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  Text(
                    'Купленные предметы',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  state.getPurchasedItems.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Вы пока ничего не купили',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: state.getPurchasedItems.length,
                          itemBuilder: (context, index) {
                            final item = state.getPurchasedItems[index];
                            return Card(
                              elevation: 3,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        _getImagePathForItem(item),
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => 
                                          Icon(Icons.shopping_bag, size: 40),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  
                  SizedBox(height: 16),
                  Text(
                    'Последняя активность',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  state.getActivityLog.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Нет активности',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.getActivityLog.length > 10 ? 10 : state.getActivityLog.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(state.getActivityLog[index]),
                              ),
                            );
                          },
                        ),
                ],
              ),
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

  String _getImagePathForItem(String itemName) {
    switch (itemName) {
      case 'Powerbank':
        return 'assets/powerbank.jpg';
      case 'Термокружка':
        return 'assets/thermo_mug.jpg';
      case 'Бутылка':
        return 'assets/water_bottle.jpg';
      case 'Портативная колонка':
        return 'assets/portable_speaker.jpg';
      case 'Музыкальная станция':
        return 'assets/music_station.jpg';
      case 'Блокнот и ручка (набор 1)':
        return 'assets/notebook_set1.jpg';
      case 'Блокнот и ручка (набор 2)':
        return 'assets/notebook_set2.jpg';
      default:
        return '';
    }
  }
}