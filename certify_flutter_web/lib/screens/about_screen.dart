import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acerca del Certificado AFD-200',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          const MarkdownBody(
            data: """
## Flutter Certified Application Developer (AFD-200)

La certificación AFD-200 (Flutter Certified Application Developer) es un examen oficial que valida tus conocimientos en desarrollo de aplicaciones móviles con Flutter.

### Información general
- **Precio**: \$150 USD
- **Duración**: 90 minutos
- **Preguntas**: Aproximadamente 45 preguntas
- **Formato**: Preguntas de opción múltiple
- **Idiomas disponibles**: Inglés y Español
- **Nota de aprobación**: 70%
- **Administrado por**: Android ATC (autorizado por Google)

### Temas principales del examen
1. **Fundamentos de Dart y POO**
   - Funciones y programación orientada a objetos
   - Instalación del IDE Dart y escritura de programas

2. **Estructura y bibliotecas de Dart**
   - Estructura de proyectos Dart
   - Creación de proyectos usando IntelliJ IDEA

3. **Clases y constructores**
   - Implementación de constructores
   - Requisitos de software para Android Studio

4. **Introducción a Flutter y Dart**
   - Conceptos básicos de Flutter
   - Sintaxis fundamental de Dart

5. **Ejecución de aplicaciones**
   - Pruebas en dispositivos Android
   - Pruebas en dispositivos iOS desde Windows

6. **Pruebas y publicación**
   - Testing y retroalimentación
   - Publicación en Google Play Store

7. **Configuración del entorno**
   - Configuración de SDK de Flutter
   - Ejecución en dispositivos físicos

8. **Navegación y rutas**
   - Implementación de técnicas de navegación
   - Diseño de interfaces con widgets

9. **Widgets y controles**
   - CheckboxGroup y RadioButtonGroup
   - RaisedButton, FlatButton e IconButton

### Consejos para aprobar
- Estudia todos los temas del temario oficial
- Realiza proyectos prácticos para consolidar conocimientos
- Practica con simulacros de examen
- Revisa la documentación oficial de Flutter y Dart
- Familiarízate con fragmentos de código y su funcionamiento
            """,
          ),
          const SizedBox(height: 32),
          Text(
            'Recursos adicionales',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            context,
            'Documentación de Flutter',
            'Consulta la documentación oficial de Flutter para aprender más sobre el framework.',
            Icons.book,
            'https://docs.flutter.dev/',
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            context,
            'Curso oficial',
            'Accede al curso oficial de preparación para la certificación AFD-200.',
            Icons.school,
            'https://androidatc.com/pages/flutter-certified-application-developer-afd-200',
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            context,
            'Foros de la comunidad',
            'Únete a la comunidad de Flutter para resolver dudas y compartir conocimientos.',
            Icons.forum,
            'https://flutter.dev/community',
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String url,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 36, color: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.open_in_new),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir $urlString');
      }
    } catch (e) {
      debugPrint('Error al abrir URL: $e');
    }
  }
}
