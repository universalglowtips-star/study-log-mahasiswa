import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/main_shell.dart';

class StudyLogApp extends StatelessWidget {
  const StudyLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study LOG',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MainShell(),
    );
  }
}
