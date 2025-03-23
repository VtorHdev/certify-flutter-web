import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/exam/exam_bloc.dart';

class ExamIntroScreen extends StatelessWidget {
  const ExamIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Simulación de Examen AFD-200',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildUnifiedInfoCard(context),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Reiniciar el estado del examen
                context.read<ExamBloc>().add(const ExamRestarted());
                // Iniciar el examen y navegar a la pantalla del examen
                context.go('/exam/start');
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar Examen'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnifiedInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Examen',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const Divider(height: 32),
            _buildInfoSection(
              context,
              title: 'Formato del Examen',
              content:
                  'El examen consta de 40 preguntas de opción múltiple seleccionadas al azar de nuestra base de datos. Cada pregunta tiene una única respuesta correcta.',
              icon: Icons.format_list_numbered,
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              context,
              title: 'Tiempo',
              content:
                  'Dispondrás de 90 minutos para completar el examen. Se mostrará un temporizador en pantalla para que puedas controlar el tiempo restante.',
              icon: Icons.timer,
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              context,
              title: 'Puntuación',
              content:
                  'Para aprobar el examen necesitas obtener al menos un 70% de respuestas correctas (28 de 40 preguntas). Al finalizar, verás un resumen detallado de tu desempeño.',
              icon: Icons.score,
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              context,
              title: 'Navegación',
              content:
                  'Puedes navegar libremente entre las preguntas y modificar tus respuestas antes de finalizar el examen.',
              icon: Icons.navigation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(content, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
