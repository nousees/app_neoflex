import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class ShopScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'name': 'Powerbank', 'cost': 5000, 'imagePath': 'assets/powerbank.jpg'},
    {'name': 'Термокружка', 'cost': 2500, 'imagePath': 'assets/thermo_mug.jpg'},
    {'name': 'Бутылка', 'cost': 2000, 'imagePath': 'assets/water_bottle.jpg'},
    {'name': 'Портативная колонка', 'cost': 4000, 'imagePath': 'assets/portable_speaker.jpg'},
    {'name': 'Музыкальная станция', 'cost': 8000, 'imagePath': 'assets/music_station.jpg'},
    {'name': 'Блокнот и ручка (набор 1)', 'cost': 1500, 'imagePath': 'assets/notebook_set1.jpg'},
    {'name': 'Блокнот и ручка (набор 2)', 'cost': 1500, 'imagePath': 'assets/notebook_set2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Магазин'),
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
                  'Магазин Neoflex',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Баланс: ${state.neoCoins} NeoCoins',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isPurchased = state.getPurchasedItems.contains(item['name']);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  item['imagePath'],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => 
                                    Icon(Icons.error, size: 50),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${item['cost']} NeoCoins',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              isPurchased
                                  ? Text(
                                      'Куплено',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (state.neoCoins >= item['cost']) {
                                          state.purchaseItem(item['name'], item['cost']);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Куплено: ${item['name']}'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Недостаточно NeoCoins!'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF6200EA),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text('Купить'),
                                    ),
                            ],
                          ),
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
    );
  }
}
