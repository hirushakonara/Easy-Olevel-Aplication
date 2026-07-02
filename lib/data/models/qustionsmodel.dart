class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String type; // 'Exam' හෝ 'Anumana'

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.type,
  });

  // Firestore දත්ත Model එකට පරිවර්තනය කිරීම (fromMap)
  factory QuestionModel.fromMap(Map<String, dynamic> data, String documentId) {
    return QuestionModel(
      id: documentId,
      question: data['question'] ?? '',
      // Firestore හි options යනු array එකක් බැවින් List<String> ලෙස ලබා ගනී
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      type: data['type'] ?? 'Exam',
    );
  }

  // Model එක Firestore වෙත යැවීමට (toMap) - අවශ්‍ය නම් පමණි
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'type': type,
    };
  }
}
