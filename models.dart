enum QType { mc, order, listen }

class Question {
  final QType type;
  final String prompt;
  final String? speak;
  final List<String> options;
  final int answerIndex;
  final List<String> words;
  final String answerText;

  const Question.mc(this.prompt, this.options, this.answerIndex, {this.speak})
      : type = QType.mc,
        words = const [],
        answerText = '';

  const Question.listen(this.prompt, String say, this.options, this.answerIndex)
      : type = QType.listen,
        speak = say,
        words = const [],
        answerText = '';

  const Question.order(this.prompt, this.words, this.answerText)
      : type = QType.order,
        options = const [],
        answerIndex = -1,
        speak = null;
}

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final bool premium;
  final List<Question> questions;

  const Lesson(this.id, this.title, this.subtitle, this.emoji, this.questions,
      {this.premium = false});
}
