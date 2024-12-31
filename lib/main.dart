import 'package:flutter/material.dart';
import 'package:printer_flutter_app/Screens/documents.dart';
import 'package:provider/provider.dart';
import 'Screens/upload.dart';
import 'Screens/accounts.dart';
import 'Providers/rollno_provider.dart';
import 'Providers/serverurl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (_) => RollNoProvider(),
  //     child: const MyApp(),
  //   ),
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RollNoProvider()),
        ChangeNotifierProvider(create: (_) => ServerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Upload App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DocumentsScreen(),
    const UploadScreen(),
    const AccountsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<String> _titles = [
    'Documents',
    'New Upload',
    'My Account',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            _titles[_currentIndex],
            style: GoogleFonts.commissioner(),
          ),
        ), // Dynamic title
        centerTitle: false, // Centers the title
        backgroundColor: Colors.white10, // Matches the app theme
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.transparent, // Adjust based on app background

        // color: const Color.fromARGB(255, 27, 27, 27), // Navigation bar color
        color: Colors.deepPurple,
        buttonBackgroundColor: Colors.deepPurple, // Active icon background
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.folder, size: 30, color: Colors.white),
          Icon(Icons.upload_file, size: 30, color: Colors.white),
          Icon(Icons.account_circle, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
