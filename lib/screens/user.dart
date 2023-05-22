import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../provider/dark_theme_provider.dart';
import '../widgets/text_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    @override
    void dispose() {
      _addressTextController.dispose();
      super.dispose();
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                    text: 'Hello, ',
                    style: TextStyle(
                      color: isDark
                          ? const Color.fromARGB(255, 79, 241, 160)
                          : const Color.fromARGB(251, 8, 109, 80),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Ammar Essajee',
                          style: TextStyle(
                            color: color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('test');
                            })
                    ]),
              ),
              const SizedBox(height: 5),
              TextWidget(
                  text: 'ammar@essajee.com',
                  color: isDark
                      ? const Color.fromARGB(255, 206, 204, 204)
                      : const Color.fromARGB(255, 60, 58, 58),
                  fontSize: 18),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              _listTiles(
                title: 'Address',
                subtitle: 'My Address',
                icon: IconlyLight.profile,
                onPressed: () async {
                  await _showAddressDialog();
                },
                color: color,
              ),
              _listTiles(
                title: 'Orders',
                subtitle: 'View recent orders',
                icon: IconlyLight.bag,
                onPressed: () {},
                color: color,
              ),
              _listTiles(
                title: 'Wishlist',
                subtitle: 'View items in your wishlist',
                icon: IconlyLight.heart,
                onPressed: () {},
                color: color,
              ),
              _listTiles(
                title: 'Viewed',
                subtitle: 'Recently vieiwed items',
                icon: IconlyLight.show,
                onPressed: () {},
                color: color,
              ),
              SwitchListTile(
                title: TextWidget(
                    text: isDark ? "Dark Mode" : "Light Mode",
                    color: color,
                    fontSize: 20),
                subtitle: TextWidget(
                    text: 'Switch between dark/light themes',
                    color: isDark
                        ? const Color.fromARGB(255, 209, 209, 209)
                        : const Color.fromARGB(255, 72, 69, 69),
                    fontSize: 16),
                activeColor: Colors.white,
                secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onChanged: (bool value) {
                  setState(() {
                    themeState.setDarkTheme = value;
                  });
                },
                value: themeState.getDarkTheme,
              ),
              _listTiles(
                title: 'Forgot Password?',
                subtitle: 'Click here to reset your password',
                icon: IconlyLight.unlock,
                onPressed: () {},
                color: color,
              ),
              _listTiles(
                title: 'Logout',
                icon: IconlyLight.logout,
                onPressed: () async {
                  await _logoutDialog();
                },
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              //onChanged: (value) {},
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Enter your address'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    print(
                        '_addressTextController ${_addressTextController.text}');
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }

  Future<void> _logoutDialog() async {
    const String logoutLogo = 'assets/images/sign-out.svg';
    final Widget logoutSvg =
        SvgPicture.asset(logoutLogo, semanticsLabel: 'Logout Logo');

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                logoutSvg,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'Sign Out?',
                    color: const Color.fromARGB(255, 39, 38, 38),
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            content: TextWidget(
                text: 'Are you sure you want to sign out?',
                color: const Color.fromARGB(255, 98, 98, 98),
                fontSize: 16),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    return ListTile(
      title: TextWidget(text: title, color: color, fontSize: 20),
      subtitle: TextWidget(
        text: subtitle ?? "",
        color: isDark
            ? const Color.fromARGB(255, 209, 209, 209)
            : const Color.fromARGB(255, 72, 69, 69),
        fontSize: 16,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
