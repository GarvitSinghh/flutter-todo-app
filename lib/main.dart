import 'package:flutter/material.dart';
import 'package:flutter_todo/config/palette.dart';
import 'package:flutter_todo/screens/hero_screen.dart';
import 'package:flutter_todo/screens/todo_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('id');

  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final int? userId;

  const MyApp({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Palette.primaryColor,
        hintColor: Palette.secondaryColor,
        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
        textTheme: GoogleFonts.hankenGroteskTextTheme(),
        useMaterial3: true,
      ),
      home: userId != null ? TodoScreen(userId: userId!) : const HeroScreen(),
    );
  }
}
