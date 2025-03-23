import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/question.dart';
import '../../repositories/questions_repository.dart';

// Events
abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object?> get props => [];
}

class QuestionsLoaded extends QuestionsEvent {
  const QuestionsLoaded();
}

class QuestionsFilteredByCategory extends QuestionsEvent {
  final String category;

  const QuestionsFilteredByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

// States
abstract class QuestionsState extends Equatable {
  const QuestionsState();

  @override
  List<Object?> get props => [];
}

class QuestionsInitial extends QuestionsState {
  const QuestionsInitial();
}

class QuestionsLoading extends QuestionsState {
  const QuestionsLoading();
}

class QuestionsLoadSuccess extends QuestionsState {
  final List<Question> questions;
  final List<String> categories;
  final String? selectedCategory;

  const QuestionsLoadSuccess({
    required this.questions,
    required this.categories,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [questions, categories, selectedCategory];

  QuestionsLoadSuccess copyWith({
    List<Question>? questions,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return QuestionsLoadSuccess(
      questions: questions ?? this.questions,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class QuestionsLoadFailure extends QuestionsState {
  final String error;

  const QuestionsLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// BLoC
class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final QuestionsRepository _questionsRepository;

  QuestionsBloc(this._questionsRepository) : super(const QuestionsInitial()) {
    on<QuestionsLoaded>(_onQuestionsLoaded);
    on<QuestionsFilteredByCategory>(_onQuestionsFilteredByCategory);
  }

  Future<void> _onQuestionsLoaded(
    QuestionsLoaded event,
    Emitter<QuestionsState> emit,
  ) async {
    emit(const QuestionsLoading());

    try {
      final questions = await _questionsRepository.loadQuestions();
      final categories = await _questionsRepository.getCategories();

      emit(QuestionsLoadSuccess(questions: questions, categories: categories));
    } catch (e) {
      emit(QuestionsLoadFailure(e.toString()));
    }
  }

  Future<void> _onQuestionsFilteredByCategory(
    QuestionsFilteredByCategory event,
    Emitter<QuestionsState> emit,
  ) async {
    if (state is QuestionsLoadSuccess) {
      final currentState = state as QuestionsLoadSuccess;

      emit(const QuestionsLoading());

      try {
        final questions = await _questionsRepository.getQuestionsByCategory(
          event.category,
        );

        emit(
          currentState.copyWith(
            questions: questions,
            selectedCategory: event.category,
          ),
        );
      } catch (e) {
        emit(QuestionsLoadFailure(e.toString()));
      }
    }
  }
}
