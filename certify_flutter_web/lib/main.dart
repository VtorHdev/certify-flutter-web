import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:certify_flutter_web/blocs/theme/theme_bloc.dart';
import 'package:certify_flutter_web/blocs/questions/questions_bloc.dart';
import 'package:certify_flutter_web/blocs/exam/exam_bloc.dart';
import 'package:certify_flutter_web/repositories/questions_repository.dart';
import 'package:certify_flutter_web/routes/app_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final questionsRepository = QuestionsRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create:
              (context) =>
                  QuestionsBloc(questionsRepository)
                    ..add(const QuestionsLoaded()),
        ),
        BlocProvider(create: (context) => ExamBloc(questionsRepository)),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final brightness =
              state.isDarkMode ? Brightness.dark : Brightness.light;

          return MaterialApp.router(
            title: 'Certify AFD-200',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: brightness,
              ),
              textTheme: GoogleFonts.nunitoTextTheme(
                ThemeData(brightness: brightness).textTheme,
              ),
              scaffoldBackgroundColor:
                  state.isDarkMode ? const Color(0xFF121212) : Colors.white,
              cardTheme: CardTheme(
                color:
                    state.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                elevation: 2,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor:
                    state.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                foregroundColor: state.isDarkMode ? Colors.white : Colors.black,
                elevation: 0,
              ),
            ),
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
