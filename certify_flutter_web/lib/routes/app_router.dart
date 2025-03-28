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
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
          ),
          GoRoute(
            path: '/study',
            builder: (context, state) => const StudyScreen(),
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const StudyScreen(),
                ),
            routes: [
              GoRoute(
                path: 'category/:categoryId',
                builder: (context, state) {
                  final categoryId = state.pathParameters['categoryId'] ?? '';
                  return StudyScreen(initialCategory: categoryId);
                },
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      key: state.pageKey,
                      child: StudyScreen(
                        initialCategory:
                            state.pathParameters['categoryId'] ?? '',
                      ),
                    ),
              ),
              GoRoute(
                path: 'question/:questionId',
                builder: (context, state) {
                  final questionId = state.pathParameters['questionId'] ?? '';
                  return QuestionDetailsScreen(questionId: questionId);
                },
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      key: state.pageKey,
                      child: QuestionDetailsScreen(
                        questionId: state.pathParameters['questionId'] ?? '',
                      ),
                    ),
              ),
            ],
          ),
          GoRoute(
            path: '/exam',
            builder: (context, state) => const ExamIntroScreen(),
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ExamIntroScreen(),
                ),
            routes: [
              GoRoute(
                path: 'start',
                builder: (context, state) => const ExamScreen(),
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      key: state.pageKey,
                      child: const ExamScreen(),
                    ),
              ),
              GoRoute(
                path: 'result',
                builder: (context, state) => const ExamResultScreen(),
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      key: state.pageKey,
                      child: const ExamResultScreen(),
                    ),
              ),
            ],
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutScreen(),
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const AboutScreen(),
                ),
          ),
        ],
      ),
    ],
    debugLogDiagnostics: kDebugMode,
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
}
