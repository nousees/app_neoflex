import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';
import '../models/education_models.dart';

class LessonDetailScreen extends StatelessWidget {
  final EducationItem educationItem;

  LessonDetailScreen({required this.educationItem});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(educationItem.title),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: educationItem.lessons.length,
            itemBuilder: (context, index) {
              final lesson = educationItem.lessons[index];
              final isCompleted = gameState.isLessonCompleted(lesson.title);
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isCompleted ? Colors.green[100] : Colors.white,
                child: ListTile(
                  title: Text(
                    lesson.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: isCompleted ? Colors.green[800] : Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonContentScreen(lesson: lesson),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LessonContentScreen extends StatelessWidget {
  final Lesson lesson;

  LessonContentScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    lesson.content,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    gameState.completeLesson(lesson.title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(lesson: lesson),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 119, 0, 255),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Пройти викторину',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final Lesson lesson;

  QuizScreen({required this.lesson});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;

  void _answerQuestion(int selectedIndex) {
    final question = widget.lesson.quiz[currentQuestionIndex];
    final gameState = Provider.of<GameState>(context, listen: false);

    if (selectedIndex == question.correctAnswerIndex) {
      correctAnswers++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Правильно!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Неправильно.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      if (currentQuestionIndex < widget.lesson.quiz.length - 1) {
        currentQuestionIndex++;
      } else {
        gameState.completeMiniQuiz();
        final coinsEarned = correctAnswers * 2;
        gameState.addCoins(coinsEarned);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Викторина завершена!'),
            content: Text('Вы ответили правильно на $correctAnswers из ${widget.lesson.quiz.length} вопросов.\n'
                'Заработано $coinsEarned NeoCoins!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Вернуться'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.lesson.quiz[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Викторина: ${widget.lesson.title}'),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Вопрос ${currentQuestionIndex + 1}/${widget.lesson.quiz.length}',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      ...question.options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            onPressed: () => _answerQuestion(index),
                            child: Text(option),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}