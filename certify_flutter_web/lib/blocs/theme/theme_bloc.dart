import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

class ThemeInitialized extends ThemeEvent {
  const ThemeInitialized();
}

// States
abstract class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

class LightTheme extends ThemeState {
  const LightTheme() : super(isDarkMode: false);
}

class DarkTheme extends ThemeState {
  const DarkTheme() : super(isDarkMode: true);
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const LightTheme()) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeInitialized>(_onThemeInitialized);
    add(const ThemeInitialized());
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    if (state is LightTheme) {
      emit(const DarkTheme());
    } else {
      emit(const LightTheme());
    }
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode') ?? 'ThemeMode.light';

    final themeMode =
        themeModeString == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light;

    if (themeMode == ThemeMode.dark) {
      emit(const DarkTheme());
    } else {
      emit(const LightTheme());
    }
  }
}
