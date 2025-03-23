import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/exam.dart';
import '../../repositories/questions_repository.dart';

// Events
abstract class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object?> get props => [];
}

class ExamStarted extends ExamEvent {
  final int questionCount;

  const ExamStarted({this.questionCount = 40});

  @override
  List<Object?> get props => [questionCount];
}

class ExamAnswerSubmitted extends ExamEvent {
  final String questionId;
  final String optionId;

  const ExamAnswerSubmitted({required this.questionId, required this.optionId});

  @override
  List<Object?> get props => [questionId, optionId];
}

class ExamFinished extends ExamEvent {
  const ExamFinished();
}

class ExamRestarted extends ExamEvent {
  const ExamRestarted();
}

// States
abstract class ExamState extends Equatable {
  const ExamState();

  @override
  List<Object?> get props => [];
}

class ExamInitial extends ExamState {
  const ExamInitial();
}

class ExamLoading extends ExamState {
  const ExamLoading();
}

class ExamInProgress extends ExamState {
  final Exam exam;
  final Map<String, String> userAnswers; // questionId -> optionId
  final int currentQuestionIndex;
  final DateTime startTime;

  const ExamInProgress({
    required this.exam,
    required this.userAnswers,
    required this.currentQuestionIndex,
    required this.startTime,
  });

  @override
  List<Object?> get props => [
    exam,
    userAnswers,
    currentQuestionIndex,
    startTime,
  ];

  ExamInProgress copyWith({
    Exam? exam,
    Map<String, String>? userAnswers,
    int? currentQuestionIndex,
    DateTime? startTime,
  }) {
    return ExamInProgress(
      exam: exam ?? this.exam,
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      startTime: startTime ?? this.startTime,
    );
  }
}

class ExamResult extends ExamState {
  final Exam exam;
  final Map<String, String> userAnswers;
  final int correctAnswersCount;
  final double percentageScore;
  final Duration duration;

  const ExamResult({
    required this.exam,
    required this.userAnswers,
    required this.correctAnswersCount,
    required this.percentageScore,
    required this.duration,
  });

  @override
  List<Object?> get props => [
    exam,
    userAnswers,
    correctAnswersCount,
    percentageScore,
    duration,
  ];
}

class ExamFailure extends ExamState {
  final String error;

  const ExamFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// BLoC
class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final QuestionsRepository _questionsRepository;

  ExamBloc(this._questionsRepository) : super(const ExamInitial()) {
    on<ExamStarted>(_onExamStarted);
    on<ExamAnswerSubmitted>(_onExamAnswerSubmitted);
    on<ExamFinished>(_onExamFinished);
    on<ExamRestarted>(_onExamRestarted);
  }

  Future<void> _onExamStarted(
    ExamStarted event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());

    try {
      final exam = await _questionsRepository.generateRandomExam(
        questionCount: event.questionCount,
      );

      emit(
        ExamInProgress(
          exam: exam,
          userAnswers: {},
          currentQuestionIndex: 0,
          startTime: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(ExamFailure(e.toString()));
    }
  }

  void _onExamAnswerSubmitted(
    ExamAnswerSubmitted event,
    Emitter<ExamState> emit,
  ) {
    if (state is ExamInProgress) {
      final currentState = state as ExamInProgress;

      // Actualizar respuestas del usuario
      final updatedUserAnswers = Map<String, String>.from(
        currentState.userAnswers,
      );
      updatedUserAnswers[event.questionId] = event.optionId;

      emit(currentState.copyWith(userAnswers: updatedUserAnswers));
    }
  }

  void _onExamFinished(ExamFinished event, Emitter<ExamState> emit) {
    if (state is ExamInProgress) {
      final currentState = state as ExamInProgress;
      final exam = currentState.exam;
      final userAnswers = currentState.userAnswers;

      // Calcular resultado
      int correctAnswersCount = 0;

      for (final question in exam.questions) {
        final userAnswer = userAnswers[question.id];
        if (userAnswer != null && userAnswer == question.correctOptionId) {
          correctAnswersCount++;
        }
      }

      final percentageScore =
          (correctAnswersCount / exam.questions.length) * 100;
      final duration = DateTime.now().difference(currentState.startTime);

      emit(
        ExamResult(
          exam: exam,
          userAnswers: userAnswers,
          correctAnswersCount: correctAnswersCount,
          percentageScore: percentageScore,
          duration: duration,
        ),
      );
    }
  }

  void _onExamRestarted(ExamRestarted event, Emitter<ExamState> emit) {
    emit(const ExamInitial());
  }
}
