import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> quizData = [
    {
      'question': 'В каком году была основана компания Neoflex?',
      'options': ['2003', '2005', '2007', '2009'],
      'correctAnswer': '2005',
    },
    {
      'question': 'Какой продукт Neoflex начал разрабатывать в 2008 году?',
      'options': ['Neoflex Datagram', 'Neoflex FrontOffice', 'Neoflex MSA Platform', 'Neoflex Reporting Risk'],
      'correctAnswer': 'Neoflex FrontOffice',
    },
    {
      'question': 'В каком году Neoflex открыл офис в Йоханнесбурге?',
      'options': ['2017', '2018', '2019', '2020'],
      'correctAnswer': '2019',
    },
    {
      'question': 'Что из перечисленного стало фокусом Neoflex в 2017 году?',
      'options': [
        'Разработка мобильных приложений',
        'Цифровая трансформация бизнеса',
        'Создание игр',
        'Автоматизация складов'
      ],
      'correctAnswer': 'Цифровая трансформация бизнеса',
    },
    {
      'question': 'Какой рост финансовых показателей Neoflex был в 2024 году?',
      'options': ['10%', '15%', '20%', '25%'],
      'correctAnswer': '25%',
    },
    {
      'question': 'В каком году Neoflex отметил 10-летний юбилей?',
      'options': ['2013', '2014', '2015', '2016'],
      'correctAnswer': '2015',
    },
    {
      'question': 'Какие практики Neoflex создал в 2010 году?',
      'options': [
        'Управление рисками и Рынки капитала',
        'Big Data и IoT',
        'Мобильная разработка',
        'DevOps и MLOps'
      ],
      'correctAnswer': 'Управление рисками и Рынки капитала',
    },
    {
      'question': 'В каком году Neoflex стал членом Ассоциации Поставщиков Кредитной Информации (ACCIS)?',
      'options': ['2018', '2019', '2020', '2021'],
      'correctAnswer': '2020',
    },
    {
      'question': 'Какое направление обучения НЕ было запущено Neoflex в 2021 году?',
      'options': ['Data Analysis', 'DevOps', 'Game Development', 'Java'],
      'correctAnswer': 'Game Development',
    },
    {
      'question': 'Какая платформа была представлена Neoflex в 2024 году для розничного кредитования?',
      'options': ['Neoflex Reporting Studio', 'Neoflex Foundation', 'Neoflex MLOps Center', 'Neoflex Datagram'],
      'correctAnswer': 'Neoflex Foundation',
    },
  ];

  void _answerQuestion(String selectedAnswer) {
    if (quizData[_currentQuestionIndex]['correctAnswer'] == selectedAnswer) {
      _correctAnswers++;
    }

    setState(() {
      if (_currentQuestionIndex < quizData.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
        _completeQuiz();
      }
    });
  }

  void _completeQuiz() {
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.completeQuiz(_correctAnswers); // Передаём количество правильных ответов
    if (_correctAnswers >= 8 && !gameState.hasCompletedQuiz) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Поздравляем! Вы получили бейдж "Эксперт по истории"!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (_correctAnswers < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Вы ответили правильно на $_correctAnswers из 10 вопросов. Попробуйте снова!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6200EA), Color(0xFFFF6200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Тест по истории Neoflex',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (!_quizCompleted) ...[
                  Text(
                    'Вопрос ${_currentQuestionIndex + 1} из ${quizData.length}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    quizData[_currentQuestionIndex]['question'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ...quizData[_currentQuestionIndex]['options'].map<Widget>((option) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _answerQuestion(option),
                        child: Text(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    );
                  }).toList(),
                ] else ...[
                  Text(
                    'Тест завершён!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Вы ответили правильно на $_correctAnswers из ${quizData.length} вопросов.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Вернуться'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF6200),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}