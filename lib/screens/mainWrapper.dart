import 'package:easyol/core/constants.dart';
import 'package:easyol/screens/qustions/qustionspage.dart';
import 'package:flutter/material.dart';
import 'home/homepage.dart';
import 'notes/notespage.dart';

import 'about/aboutpage.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // පිටු ලැයිස්තුව
  final List<Widget> _pages = [
    HomePage(),
    NotesPage(),
    QuestionPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack භාවිතා කිරීමෙන් state එක පවත්වා ගනී
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Tabs 4ක් ඇති විට මෙය අනිවාර්ය වේ
        selectedItemColor: kPrimaryBlue, // Blue theme
        unselectedItemColor: kPrimaryPurple, // Purple theme
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            activeIcon: Icon(Icons.note_alt),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
