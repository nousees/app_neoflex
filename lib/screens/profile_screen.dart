import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;
  String? firstName;
  String? lastName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final dataList = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .limit(1);
      if (dataList != null && dataList.isNotEmpty) {
        final data = dataList[0];
        setState(() {
          firstName = data['first_name'] ?? '';
          lastName = data['last_name'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          firstName = '';
          lastName = '';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
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
  Widget build(BuildContext context) {
    if (isLoading)
      return Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Личный кабинет'),
        backgroundColor: const Color(0xFF6200EA),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6200EA), Color(0xFFFF6200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<GameState>(
          builder: (context, state, _) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Профиль',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        tooltip: 'Редактировать',
                        onPressed: () async {
                          final result = await showDialog<Map<String, String>>(
                            context: context,
                            builder: (context) {
                              final _nameController = TextEditingController(text: firstName ?? '');
                              final _surnameController = TextEditingController(text: lastName ?? '');
                              return AlertDialog(
                                title: Text('Редактировать профиль'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(labelText: 'Имя'),
                                    ),
                                    TextField(
                                      controller: _surnameController,
                                      decoration: InputDecoration(labelText: 'Фамилия'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Отмена'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, {
                                        'first_name': _nameController.text,
                                        'last_name': _surnameController.text,
                                      });
                                    },
                                    child: Text('Сохранить'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (result != null) {
                            setState(() { isLoading = true; });
                            final user = Supabase.instance.client.auth.currentUser;
                            await Supabase.instance.client
                                .from('profiles')
                                .update({
                                  'first_name': result['first_name'],
                                  'last_name': result['last_name'],
                                })
                                .eq('id', user!.id);
                            setState(() {
                              firstName = result['first_name'];
                              lastName = result['last_name'];
                              isLoading = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Имя: ${firstName ?? '-'}\nФамилия: ${lastName ?? '-'}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Информация'),
                      subtitle: Text(
                        'NeoCoins: ${state.neoCoins}\n'
                        'Серия входов: ${state.loginStreak} дней\n'
                        'Сыграно игр: ${state.techTapScores.length + state.codeMatchScores.length}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Бейджи'),
                      subtitle: Text(
                          'Получено ${state.unlockedBadges.length} из ${state.allBadges.length}'),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/badges'),
                        child: const Text('Посмотреть все'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Купленные предметы',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  state.getPurchasedItems.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Вы пока ничего не купили',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        _getImagePathForItem(item),
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.shopping_bag,
                                                    size: 40),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item,
                                      style: const TextStyle(
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
                  const SizedBox(height: 16),
                  const Text(
                    'Последняя активность',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  state.getActivityLog.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Нет активности',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.getActivityLog.length > 10
                              ? 10
                              : state.getActivityLog.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Игры'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Рейтинг'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF6200),
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