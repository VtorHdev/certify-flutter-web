import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import '../models/question.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final VoidCallback? onTap;
  final bool showAnswer;
  final String? selectedOptionId;
  final Function(String)? onOptionSelected;

  const QuestionCard({
    Key? key,
    required this.question,
    this.onTap,
    this.showAnswer = false,
    this.selectedOptionId,
    this.onOptionSelected,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? _localSelectedOptionId;

  @override
  void initState() {
    super.initState();
    _localSelectedOptionId = widget.selectedOptionId;
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOptionId != widget.selectedOptionId) {
      _localSelectedOptionId = widget.selectedOptionId;
    }
  }

  void _selectOption(String optionId) {
    setState(() {
      _localSelectedOptionId = optionId;
    });
    if (widget.onOptionSelected != null) {
      widget.onOptionSelected!(optionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categoría
                Expanded(
                  child: Chip(
                    label: Text(widget.question.category),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                // Icono para indicar expansión
                if (widget.onTap != null && widget.showAnswer)
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_up),
                    onPressed: widget.onTap,
                    tooltip: 'Cerrar respuesta',
                    color: theme.colorScheme.primary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Pregunta
            Text(widget.question.text, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            // Fragmento de código (si existe)
            if (widget.question.codeSnippet != null) ...[
              const SizedBox(height: 8),
              SyntaxView(
                code: widget.question.codeSnippet!,
                syntax: Syntax.DART,
                syntaxTheme:
                    Theme.of(context).brightness == Brightness.dark
                        ? SyntaxTheme.dracula()
                        : SyntaxTheme.vscodeDark(),
                fontSize: 12,
                withZoom: false,
                withLinesCount: true,
                expanded: false,
              ),
              const SizedBox(height: 12),
            ],
            // Opciones
            ...widget.question.options.map(
              (option) => _buildOptionTile(context, option),
            ),
            // Si se debe mostrar la respuesta correcta
            if (widget.showAnswer) ...[
              const Divider(height: 32),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Respuesta correcta: ${_getCorrectOptionText()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Explicación:', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(widget.question.explanation),
            ] else if (!widget.showAnswer &&
                _localSelectedOptionId != null) ...[
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Verificar respuesta'),
                  onPressed: widget.onTap,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, QuestionOption option) {
    final bool isSelected = _localSelectedOptionId == option.id;
    final bool isCorrect = widget.question.correctOptionId == option.id;
    final bool showCorrectness = widget.showAnswer && isSelected;
    final bool isIncorrectSelected =
        widget.showAnswer && isSelected && !isCorrect;

    Color? backgroundColor;
    if (widget.showAnswer && isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.2);
    } else if (isIncorrectSelected) {
      backgroundColor = Colors.red.withOpacity(0.2);
    } else if (isSelected) {
      backgroundColor = Theme.of(
        context,
      ).colorScheme.primaryContainer.withOpacity(0.3);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: widget.showAnswer ? null : () => _selectOption(option.id),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                Text(
                  '${option.id}.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(option.text)),
                if (isSelected)
                  Icon(
                    showCorrectness
                        ? (isCorrect ? Icons.check_circle : Icons.cancel)
                        : Icons.radio_button_checked,
                    color:
                        showCorrectness
                            ? (isCorrect ? Colors.green : Colors.red)
                            : Theme.of(context).colorScheme.primary,
                  ),
                if (widget.showAnswer && isCorrect && !isSelected)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCorrectOptionText() {
    final correctOption = widget.question.options.firstWhere(
      (option) => option.id == widget.question.correctOptionId,
    );
    return '${correctOption.id}. ${correctOption.text}';
  }
}
