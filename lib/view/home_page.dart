import 'package:chatgptuz/view/chatgpt_page.dart';
import 'package:chatgptuz/view/gemini_page.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ChatgptPage(),
    GeminiPage(),
    Center(child: Text("Uchinchi sahifa")),
  ];

  void _onSelectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Drawer menyusini yopish
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Foydalanuvchi", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("ChatGPT"),
              onTap: () => _onSelectPage(0),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Sozlamalar"),
              onTap: () => _onSelectPage(1),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Haqida"),
              onTap: () => _onSelectPage(2),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}