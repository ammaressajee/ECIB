import 'package:ecib/screens/about_us.dart';
import 'package:ecib/screens/audio_player_screen.dart';
import 'package:ecib/screens/cart.dart';
import 'package:ecib/screens/categories.dart';
import 'package:ecib/screens/home_screen.dart';
import 'package:ecib/screens/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home'},
    {'page': const CategoriesScreen(), 'title': 'Categories'},
    {'page': const ScaleFinderScreen(), 'title': 'Recording Studio'},
    {'page': const AudioPlayerScreen(), 'title': 'Music Player'},
    {'page': const UserScreen(), 'title': 'User Profile'},
    {'page': const AboutUsScreen(), 'title': 'About Us'},
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedIndex]['title'],
          style: TextStyle(
              color: _isDark
                  ? Color.fromARGB(255, 239, 248, 245)
                  : const Color.fromARGB(255, 187, 214, 199)),
        ),
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: themeState.getDarkTheme
              ? Theme.of(context).cardColor
              : Colors.white,
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Colors.greenAccent,
          currentIndex: _selectedIndex,
          onTap: _selectedPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? IconlyBold.category
                  : IconlyLight.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2
                  ? FontAwesomeIcons.microphoneLines
                  : FontAwesomeIcons.microphoneLines),
              label: 'Studio',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3
                  ? FontAwesomeIcons.headphones
                  : FontAwesomeIcons.headphones),
              label: 'Audio Player',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 5 ? IconlyBold.user2 : IconlyLight.user2),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 6
                  ? IconlyBold.infoSquare
                  : IconlyLight.infoSquare),
              label: 'About Us',
            ),
          ]),
    );
  }
}
