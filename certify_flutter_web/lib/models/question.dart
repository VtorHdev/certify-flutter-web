class Question {
  final String id;
  final String text;
  final List<QuestionOption> options;
  final String correctOptionId;
  final String explanation;
  final String category;
  final String? codeSnippet;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    required this.category,
    this.codeSnippet,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options:
          (json['options'] as List)
              .map((option) => QuestionOption.fromJson(option))
              .toList(),
      correctOptionId: json['correctOptionId'],
      explanation: json['explanation'],
      category: json['category'],
      codeSnippet: json['codeSnippet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options.map((option) => option.toJson()).toList(),
      'correctOptionId': correctOptionId,
      'explanation': explanation,
      'category': category,
      'codeSnippet': codeSnippet,
    };
  }
}

class QuestionOption {
  final String id;
  final String text;

  QuestionOption({required this.id, required this.text});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(id: json['id'], text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}
