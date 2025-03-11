import 'package:chatgptuz/consts.dart';
import 'package:chatgptuz/database/database_helper.dart';
import 'package:chatgptuz/view/chatgpt_pages/conversation_provider.dart';
import 'package:chatgptuz/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY);
  WidgetsFlutterBinding.ensureInitialized();
  await _insertInitialData();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConversationProvider(),
      child: MyApp(),
    ),
  );
}
Future<void> _insertInitialData() async {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> sections = await db.getSections();

  if (sections.isEmpty) {
    await db.addSection({"title": "Introduction", "time": "7 min", "completed": 0, "color": "#6A5ACD"}); // Purple
    await db.addSection({"title": "The Art of Talking to AI", "time": "5 min", "completed": 0, "color": "#DC143C"}); // Red
    await db.addSection({"title": "Basics of Prompting", "time": "7 min", "completed": 0, "color": "#8A2BE2"}); // Blue-Violet
    await db.addSection({"title": "Prompt Types", "time": "7 min", "completed": 0, "color": "#DAA520"}); // Goldenrod
    await db.addSection({"title": "Prompting Techniques", "time": "5 min", "completed": 0, "color": "#228B22"}); // Green
    await db.addSection({"title": "Prompting Techniques", "time": "5 min", "completed": 0, "color": "#228B22"}); // Green
  }
}
class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData(
    primarySwatch: Colors.grey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Chat App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: HomePage(),
    );
  }
}
