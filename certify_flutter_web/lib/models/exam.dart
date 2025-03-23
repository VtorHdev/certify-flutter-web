import 'question.dart';

class Exam {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int durationMinutes;
  final DateTime createdAt;

  Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.durationMinutes,
    required this.createdAt,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions:
          (json['questions'] as List)
              .map((question) => Question.fromJson(question))
              .toList(),
      durationMinutes: json['durationMinutes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((question) => question.toJson()).toList(),
      'durationMinutes': durationMinutes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
