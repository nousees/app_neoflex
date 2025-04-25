import 'package:flutter/material.dart';

class EducationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Lesson> lessons;

  EducationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.lessons,
  });
}

class Lesson {
  final String title;
  final String content;
  final List<QuizQuestion> quiz;

  Lesson({
    required this.title,
    required this.content,
    required this.quiz,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}