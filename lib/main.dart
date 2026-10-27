import 'package:flutter/material.dart';
import 'pages/discover.dart';

void main() => runApp(const MyApp());
const matchPink = Color(0xFFE94B78);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "It's a Match!",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: matchPink,
        primary: matchPink,
      ),
      scaffoldBackgroundColor: const Color(0xFFFBF7F5),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: const Color(0xFF302531),
        displayColor: const Color(0xFF302531),
      ),
    ),

    home: const DiscoverPage(),
  );
}
