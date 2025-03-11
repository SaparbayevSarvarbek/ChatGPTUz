import 'package:chatgptuz/database/database_helper.dart';
import 'package:chatgptuz/view/ai_page.dart';
import 'package:chatgptuz/view/chatgpt_pages/chatgpt_home_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> sections = [];

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    final db = DatabaseHelper.instance;
    final data = await db.getSections();
    setState(() {
      sections = data;
    });
  }

  Future<void> _markAsRead(int id) async {
    final db = DatabaseHelper.instance;
    await db.updateSection(id, 1);
    _loadSections();
  }

  Color _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.grey; // Default rang
    hex = hex.replaceAll("#", "");
    return Color(int.parse("0xFF$hex"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatgptHomePage()),
              ).then((_) {
                _markAsRead(section["id"]);
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: _hexToColor(section["color"]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  section["title"] ?? "No Title",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  section["time"] ?? "",
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: section["completed"] == 1
                    ? Icon(Icons.check_circle, color: Colors.white)
                    : Icon(Icons.lock_outline, color: Colors.white),
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Foydalanuvchi ismi"),
              accountEmail: Text("email@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/profile.png'), // Profil rasmi
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.blue),
              title: Text('Darslar'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.smart_toy, color: Colors.green),
              title: Text('Sun’iy Intellekt'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AiPage()));
              },
            ),
            Divider(), // Chiziq
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Chiqish'),
              onTap: () {
                // Logout qilish yoki ilovadan chiqish
              },
            ),
          ],
        ),
      ),
    );
  }
}
