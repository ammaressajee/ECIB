import 'package:ecib/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        print('Category pressed');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 169, 174, 169).withOpacity(0.2),
          border: Border.all(
              color: const Color.fromARGB(199, 93, 93, 93).withOpacity(0.7),
              width: 1),
        ),
        child: Column(
          children: [
            Container(
              height: _screenWidth * 0.3,
              width: _screenWidth * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/spiral.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            TextWidget(
                text: 'Category Name',
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18)
          ],
        ),
      ),
    );
  }
}
