import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/questions/questions_bloc.dart';
import '../models/question.dart';
import '../widgets/question_card.dart';

class QuestionDetailsScreen extends StatelessWidget {
  final String questionId;

  const QuestionDetailsScreen({Key? key, required this.questionId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionsBloc, QuestionsState>(
      builder: (context, state) {
        if (state is QuestionsLoadSuccess) {
          final question = _findQuestionById(state.questions, questionId);

          if (question != null) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuestionCard(question: question, showAnswer: true),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver al listado'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                'Pregunta no encontrada',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Question? _findQuestionById(List<Question> questions, String id) {
    try {
      return questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
}
