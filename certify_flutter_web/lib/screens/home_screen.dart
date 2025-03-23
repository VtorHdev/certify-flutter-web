import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcular ancho disponible para adaptar los cards
    final screenWidth = MediaQuery.of(context).size.width;
    final useGrid = screenWidth > 800;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.flutter_dash, size: 120, color: Colors.blue),
            const SizedBox(height: 32),
            Text(
              'Preparación para AFD-200',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Flutter Certified Application Developer',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: const Text(
                'Mejora tus conocimientos y prepárate para obtener la certificación oficial de Flutter con nuestra colección de preguntas y exámenes de práctica.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 48),

            // Usar un grid o column dependiendo del tamaño de pantalla
            if (useGrid)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  children: _buildFeatureCards(context),
                ),
              )
            else
              Column(
                children: [
                  _buildFeatureCard(
                    context,
                    title: 'Modo Estudio',
                    description:
                        'Estudia por categorías y revisa todas las preguntas con sus explicaciones detalladas',
                    icon: Icons.book,
                    color: Colors.green,
                    onTap: () => context.go('/study'),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    title: 'Simulacro de Examen',
                    description:
                        '40 preguntas aleatorias con 90 minutos para simular el examen real',
                    icon: Icons.quiz,
                    color: Colors.orange,
                    onTap: () => context.go('/exam'),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    title: 'Acerca del Certificado',
                    description:
                        'Información sobre el examen AFD-200 y consejos para aprobarlo',
                    icon: Icons.info,
                    color: Colors.blue,
                    onTap: () => context.go('/about'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Lista de feature cards para el grid
  List<Widget> _buildFeatureCards(BuildContext context) {
    return [
      _buildFeatureCard(
        context,
        title: 'Modo Estudio',
        description:
            'Estudia por categorías y revisa todas las preguntas con sus explicaciones detalladas',
        icon: Icons.book,
        color: Colors.green,
        onTap: () => context.go('/study'),
      ),
      _buildFeatureCard(
        context,
        title: 'Simulacro de Examen',
        description:
            '40 preguntas aleatorias con 90 minutos para simular el examen real',
        icon: Icons.quiz,
        color: Colors.orange,
        onTap: () => context.go('/exam'),
      ),
      _buildFeatureCard(
        context,
        title: 'Acerca del Certificado',
        description:
            'Información sobre el examen AFD-200 y consejos para aprobarlo',
        icon: Icons.info,
        color: Colors.blue,
        onTap: () => context.go('/about'),
      ),
    ];
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
