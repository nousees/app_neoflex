import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final gameState = Provider.of<GameState>(context, listen: false);
      await gameState.handleDailyLogin();
    });
  }

  final List<Map<String, dynamic>> dailyRewards = [
    {'day': 1, 'reward': '10 NeoCoins'},
    {'day': 2, 'reward': '15 NeoCoins'},
    {'day': 3, 'reward': '20 NeoCoins'},
    {'day': 4, 'reward': '25 NeoCoins'},
    {'day': 5, 'reward': '30 NeoCoins'},
    {'day': 6, 'reward': '35 NeoCoins'},
    {'day': 7, 'reward': '50 NeoCoins + Бейдж "Week Starter"'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Награды за вход'),
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
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ваши награды',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text('Текущая серия входов'),
                      subtitle: Text('${state.loginStreak} дней'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ежедневные награды',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dailyRewards.length + 1,
                      itemBuilder: (context, index) {
                        if (index < dailyRewards.length) {
                          final reward = dailyRewards[index];
                          final isCompleted = state.loginStreak >= index + 1;
                          return Card(
                            child: ListTile(
                              title: Text('День ${reward['day']}'),
                              subtitle: Text(reward['reward']),
                              trailing: isCompleted
                                  ? Icon(Icons.check_circle, color: Colors.green)
                                  : Icon(Icons.lock, color: Colors.grey),
                            ),
                          );
                        } else {
                          return Card(
                            child: ListTile(
                              title: Text('День 8+'),
                              subtitle: Text('5 NeoCoins за вход'),
                              trailing: state.loginStreak > 7
                                  ? Icon(Icons.check_circle, color: Colors.green)
                                  : Icon(Icons.lock, color: Colors.grey),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}