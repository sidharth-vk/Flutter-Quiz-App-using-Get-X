// lib/models/question.dart
class Question {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String? option5;
  final String answer;
  final String explanation;

  Question({
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    this.option5,
    required this.answer,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      option4: json['option4'],
      option5: json['option5'],
      answer: json['answer'],
      explanation: json['explanation'],
    );
  }
}
