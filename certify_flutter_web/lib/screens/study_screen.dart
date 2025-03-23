import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/questions/questions_bloc.dart';
import '../widgets/question_card.dart';

class StudyScreen extends StatefulWidget {
  final String? initialCategory;

  const StudyScreen({Key? key, this.initialCategory}) : super(key: key);

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  // Set para almacenar los IDs de las preguntas que están expandidas
  final Set<String> _expandedQuestionIds = {};
  // Map para almacenar las respuestas seleccionadas por el usuario
  final Map<String, String> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    // Cargar las preguntas
    context.read<QuestionsBloc>().add(const QuestionsLoaded());

    // Si hay una categoría inicial, filtrar por ella
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<QuestionsBloc>().add(
          QuestionsFilteredByCategory(widget.initialCategory!),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionsBloc, QuestionsState>(
      builder: (context, state) {
        if (state is QuestionsInitial || state is QuestionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QuestionsLoadSuccess) {
          return Column(
            children: [
              _buildCategorySelector(context, state),
              Expanded(child: _buildQuestionsList(context, state)),
            ],
          );
        } else if (state is QuestionsLoadFailure) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        } else {
          return const Center(child: Text('Estado desconocido'));
        }
      },
    );
  }

  Widget _buildCategorySelector(
    BuildContext context,
    QuestionsLoadSuccess state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categorías', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final isSelected = category == state.selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (selected) {
                      if (selected) {
                        // Limpiar el estado al cambiar de categoría
                        setState(() {
                          _expandedQuestionIds.clear();
                          _selectedOptions.clear();
                        });

                        context.read<QuestionsBloc>().add(
                          QuestionsFilteredByCategory(category),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsList(BuildContext context, QuestionsLoadSuccess state) {
    if (state.questions.isEmpty) {
      return const Center(
        child: Text('No hay preguntas disponibles en esta categoría'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.questions.length,
      itemBuilder: (context, index) {
        final question = state.questions[index];
        final isExpanded = _expandedQuestionIds.contains(question.id);
        final selectedOption = _selectedOptions[question.id];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: QuestionCard(
            question: question,
            showAnswer: isExpanded,
            selectedOptionId: selectedOption,
            onOptionSelected: (optionId) {
              setState(() {
                _selectedOptions[question.id] = optionId;
              });
            },
            onTap: () {
              // Solo mostrar la respuesta cuando hay una opción seleccionada
              if (_selectedOptions.containsKey(question.id)) {
                setState(() {
                  if (isExpanded) {
                    _expandedQuestionIds.remove(question.id);
                  } else {
                    _expandedQuestionIds.add(question.id);
                  }
                });
              }
            },
          ),
        );
      },
    );
  }
}
