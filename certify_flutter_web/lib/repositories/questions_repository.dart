import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../models/exam.dart';

class QuestionsRepository {
  // Lista en memoria de preguntas
  List<Question> _questions = [];
  List<String> _categories = [];

  // Carga las preguntas desde un archivo JSON local
  Future<List<Question>> loadQuestions() async {
    if (_questions.isNotEmpty) {
      return _questions;
    }

    try {
      String jsonString;

      // Para entornos web en producción (como GitHub Pages), intentamos usar la ruta absoluta
      if (kIsWeb) {
        try {
          // Intenta obtener el asset usando HTTP para entornos web
          final basePath = Uri.base.toString();
          final assetUrl = '${basePath}assets/assets/data/questions.json';
          debugPrint('Intentando cargar preguntas desde: $assetUrl');

          final response = await http.get(Uri.parse(assetUrl));
          if (response.statusCode == 200) {
            jsonString = response.body;
            debugPrint('Preguntas cargadas exitosamente via HTTP');
          } else {
            // Si falla, intenta con el método estándar
            jsonString = await rootBundle.loadString(
              'assets/data/questions.json',
            );
            debugPrint(
              'Preguntas cargadas vía rootBundle después de fallar HTTP',
            );
          }
        } catch (httpError) {
          debugPrint('Error cargando via HTTP: $httpError');
          // Si falla el HTTP, intentamos con rootBundle
          jsonString = await rootBundle.loadString(
            'assets/data/questions.json',
          );
        }
      } else {
        // Para entornos no web, usamos el método estándar
        jsonString = await rootBundle.loadString('assets/data/questions.json');
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      _questions = jsonList.map((json) => Question.fromJson(json)).toList();
      _updateCategories();
      debugPrint('Cargadas ${_questions.length} preguntas exitosamente');
      return _questions;
    } catch (e) {
      debugPrint('Error cargando preguntas: $e');
      // Si no puede cargar desde assets, intenta cargar un conjunto de preguntas de muestra
      _loadSampleQuestions();
      return _questions;
    }
  }

  // Actualiza la lista de categorías basada en las preguntas disponibles
  void _updateCategories() {
    final Set<String> categorySet = {};
    for (var question in _questions) {
      categorySet.add(question.category);
    }
    _categories = categorySet.toList()..sort();
  }

  // Carga preguntas de muestra en caso de que no se pueda acceder al archivo JSON
  void _loadSampleQuestions() {
    _questions = [
      Question(
        id: '1',
        text: '¿Qué widget permite crear una lista de elementos desplazable?',
        options: [
          QuestionOption(id: 'A', text: 'Container'),
          QuestionOption(id: 'B', text: 'ListView'),
          QuestionOption(id: 'C', text: 'Row'),
          QuestionOption(id: 'D', text: 'Column'),
        ],
        correctOptionId: 'B',
        explanation:
            'ListView es un widget que muestra sus hijos uno tras otro en la dirección de desplazamiento.',
        category: 'Widgets',
      ),
      Question(
        id: '2',
        text: '¿Cuál es la diferencia entre StatelessWidget y StatefulWidget?',
        options: [
          QuestionOption(id: 'A', text: 'No hay diferencia'),
          QuestionOption(id: 'B', text: 'StatelessWidget es más rápido'),
          QuestionOption(
            id: 'C',
            text: 'StatefulWidget no puede ser actualizado',
          ),
          QuestionOption(
            id: 'D',
            text:
                'StatefulWidget puede cambiar su apariencia en respuesta a eventos',
          ),
        ],
        correctOptionId: 'D',
        explanation:
            'Un StatefulWidget puede cambiar su apariencia en respuesta a eventos o cuando recibe datos.',
        category: 'Fundamentos',
      ),
    ];

    _updateCategories();
  }

  // Obtiene las preguntas por categoría
  Future<List<Question>> getQuestionsByCategory(String category) async {
    await loadQuestions();
    return _questions.where((q) => q.category == category).toList();
  }

  // Obtiene todas las categorías disponibles
  Future<List<String>> getCategories() async {
    await loadQuestions();
    return _categories;
  }

  // Genera un examen aleatorio con un número dado de preguntas
  Future<Exam> generateRandomExam({int questionCount = 40}) async {
    await loadQuestions();

    if (_questions.isEmpty) {
      throw Exception('No hay preguntas disponibles para generar el examen');
    }

    // Hacer una copia de la lista de preguntas para poder mezclarla
    final List<Question> shuffledQuestions = List.from(_questions);
    shuffledQuestions.shuffle();

    // Limitar al número deseado de preguntas
    final List<Question> examQuestions =
        shuffledQuestions.take(questionCount).toList();

    return Exam(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Simulacro de Examen AFD-200',
      description: 'Examen de práctica con $questionCount preguntas aleatorias',
      questions: examQuestions,
      durationMinutes: 90,
      createdAt: DateTime.now(),
    );
  }

  // Obtiene preguntas aleatorias para un examen
  Future<List<Question>> getRandomQuestionsForExam(int count) async {
    final questions = await loadQuestions();

    // Si hay menos preguntas disponibles que las solicitadas, devolver todas
    if (questions.length <= count) {
      return List<Question>.from(questions);
    }

    // Mezclar las preguntas y tomar las primeras 'count'
    final shuffled = List<Question>.from(questions)..shuffle();
    return shuffled.take(count).toList();
  }

  // Obtiene las categorías de una lista de preguntas
  List<String> getCategoriesFromList(List<Question> questions) {
    // Extraer todas las categorías únicas
    final Set<String> categories = {};

    for (final question in questions) {
      categories.add(question.category);
    }

    return categories.toList()..sort();
  }
}
