import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/exam/exam_bloc.dart';
import '../widgets/question_card.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state is ExamResult) {
          final isPassed = state.percentageScore >= 70.0;

          return Column(
            children: [
              _buildResultHeader(context, state, isPassed),
              Expanded(child: _buildQuestionsList(context, state)),
              _buildActionsBar(context),
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No hay resultados disponibles'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.go('/exam');
                  },
                  child: const Text('Iniciar un examen'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildResultHeader(
    BuildContext context,
    ExamResult state,
    bool isPassed,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final minutes = state.duration.inMinutes;
    final seconds = state.duration.inSeconds % 60;
    final timeText = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(24.0),
      color:
          isPassed
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPassed ? Icons.check_circle : Icons.cancel,
                color: isPassed ? Colors.green : Colors.red,
                size: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPassed ? '¡Aprobado!' : 'No aprobado',
                      style: textTheme.headlineMedium?.copyWith(
                        color: isPassed ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isPassed
                          ? 'Felicidades, has superado el examen'
                          : 'Sigue practicando y vuelve a intentarlo',
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _resultItem(
                      context,
                      title: 'Puntuación',
                      value: '${state.percentageScore.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                    ),
                    _resultItem(
                      context,
                      title: 'Correctas',
                      value:
                          '${state.correctAnswersCount}/${state.exam.questions.length}',
                      icon: Icons.check,
                    ),
                    _resultItem(
                      context,
                      title: 'Tiempo',
                      value: timeText,
                      icon: Icons.timer,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: state.percentageScore / 100,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                  color: isPassed ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text('Aprobado: 70%', style: textTheme.bodySmall)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildQuestionsList(BuildContext context, ExamResult state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.exam.questions.length,
      itemBuilder: (context, index) {
        final question = state.exam.questions[index];
        final userOptionId = state.userAnswers[question.id];
        final isCorrect = userOptionId == question.correctOptionId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ExpansionTile(
            title: Text(
              'Pregunta ${index + 1}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              question.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: CircleAvatar(
              backgroundColor: isCorrect ? Colors.green : Colors.red,
              child: Icon(
                isCorrect ? Icons.check : Icons.close,
                color: Colors.white,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuestionCard(
                  question: question,
                  showAnswer: true,
                  selectedOptionId: userOptionId,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionsBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              context.go('/study');
            },
            icon: const Icon(Icons.book),
            label: const Text('Modo estudio'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ExamBloc>().add(const ExamRestarted());
              context.go('/exam');
            },
            icon: const Icon(Icons.replay),
            label: const Text('Nuevo examen'),
          ),
        ],
      ),
    );
  }
}
