import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import '../screens/home_screen.dart';
import '../screens/study_screen.dart';
import '../screens/exam_intro_screen.dart';
import '../screens/exam_screen.dart';
import '../screens/question_details_screen.dart';
import '../screens/exam_result_screen.dart';
import '../screens/about_screen.dart';
import '../widgets/page_scaffold.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return PageScaffold(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/study',
            builder: (context, state) => const StudyScreen(),
            routes: [
              GoRoute(
                path: 'category/:categoryId',
                builder: (context, state) {
                  final categoryId = state.pathParameters['categoryId'] ?? '';
                  return StudyScreen(initialCategory: categoryId);
                },
              ),
              GoRoute(
                path: 'question/:questionId',
                builder: (context, state) {
                  final questionId = state.pathParameters['questionId'] ?? '';
                  return QuestionDetailsScreen(questionId: questionId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/exam',
            builder: (context, state) => const ExamIntroScreen(),
            routes: [
              GoRoute(
                path: 'start',
                builder: (context, state) => const ExamScreen(),
              ),
              GoRoute(
                path: 'result',
                builder: (context, state) => const ExamResultScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
    ],
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      if (kIsWeb && !_isValidPath(state.matchedLocation)) {
        return '/';
      }
      return null;
    },
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: Ruta no encontrada: ${state.uri.path}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Volver al Inicio'),
                ),
              ],
            ),
          ),
        ),
  );

  static bool _isValidPath(String path) {
    final validPaths = ['/', '/study', '/exam', '/about'];

    if (validPaths.contains(path)) {
      return true;
    }

    if (path.startsWith('/study/category/') ||
        path.startsWith('/study/question/') ||
        path.startsWith('/exam/start') ||
        path.startsWith('/exam/result')) {
      return true;
    }

    return false;
  }
}
