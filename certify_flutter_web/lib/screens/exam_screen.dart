import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../blocs/exam/exam_bloc.dart';
import '../widgets/question_card.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  Timer? _timer;
  Duration _timeRemaining = const Duration(minutes: 90);
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Iniciar un nuevo examen
    context.read<ExamBloc>().add(const ExamStarted());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.inSeconds > 0) {
        setState(() {
          _timeRemaining = _timeRemaining - const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        _finishExam();
      }
    });
  }

  void _finishExam() {
    _timer?.cancel();
    context.read<ExamBloc>().add(const ExamFinished());
    context.go('/exam/result');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamInProgress && _timer == null) {
          // Iniciar el temporizador cuando el examen está listo
          _timeRemaining = Duration(minutes: state.exam.durationMinutes);
          _startTimer();
        }
      },
      builder: (context, state) {
        if (state is ExamInitial || state is ExamLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExamInProgress) {
          final questions = state.exam.questions;
          final currentQuestion = questions[_currentQuestionIndex];
          final userAnswer = state.userAnswers[currentQuestion.id];

          return Column(
            children: [
              // Barra de progreso y tiempo
              _buildProgressBar(context, state),

              // Pregunta actual
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: QuestionCard(
                    question: currentQuestion,
                    selectedOptionId: userAnswer,
                    onOptionSelected: (optionId) {
                      context.read<ExamBloc>().add(
                        ExamAnswerSubmitted(
                          questionId: currentQuestion.id,
                          optionId: optionId,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Botones de navegación
              _buildNavigationButtons(context, state),
            ],
          );
        } else if (state is ExamFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.error}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ExamBloc>().add(const ExamStarted());
                  },
                  child: const Text('Intentar de nuevo'),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Estado desconocido'));
        }
      },
    );
  }

  Widget _buildProgressBar(BuildContext context, ExamInProgress state) {
    final exam = state.exam;
    final totalQuestions =
        exam.questions.length; // Será 40 según la configuración
    final answeredQuestions = state.userAnswers.length;
    final progress = (_currentQuestionIndex + 1) / totalQuestions;
    final percentComplete = answeredQuestions / totalQuestions;

    // Formato del tiempo restante
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;
    final timeText =
        '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pregunta ${_currentQuestionIndex + 1} de $totalQuestions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Tiempo: $timeText',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _timeRemaining.inMinutes < 10 ? Colors.red : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Respondidas: $answeredQuestions de $totalQuestions',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Progreso: ${(percentComplete * 100).round()}%',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, ExamInProgress state) {
    final questions = state.exam.questions;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón Anterior
          ElevatedButton(
            onPressed:
                _currentQuestionIndex > 0
                    ? () {
                      setState(() {
                        _currentQuestionIndex--;
                      });
                    }
                    : null,
            child: const Text('Anterior'),
          ),

          // Botón Terminar
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Finalizar examen'),
                      content: Text(
                        'Has respondido ${state.userAnswers.length} de ${questions.length} preguntas. '
                        '¿Estás seguro de que quieres finalizar el examen?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _finishExam();
                          },
                          child: const Text('Finalizar'),
                        ),
                      ],
                    ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Terminar examen'),
          ),

          // Botón Siguiente
          ElevatedButton(
            onPressed:
                _currentQuestionIndex < questions.length - 1
                    ? () {
                      setState(() {
                        _currentQuestionIndex++;
                      });
                    }
                    : null,
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
