import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeMon App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3D7DCA),
          primary: const Color(0xFF3D7DCA),
          secondary: const Color(0xFF3D7DCA),
        ),
        useMaterial3: true,

        textTheme: GoogleFonts.quattrocentoSansTextTheme(),
      ),
      home: HomePage(),
    );
  }
}
