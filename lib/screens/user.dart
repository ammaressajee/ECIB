import 'package:ecib/screens/login_screen.dart';
import 'package:ecib/utils/next_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../provider/dark_theme_provider.dart';
import '../provider/sign_in_provider.dart';
import '../widgets/text_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressStreetTextController =
      TextEditingController(text: "");
  final TextEditingController _addressCityTextController =
      TextEditingController(text: "");
  final TextEditingController _addressStateTextController =
      TextEditingController(text: "");
  final TextEditingController _addressZipTextController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getUserDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    @override
    void dispose() {
      _addressStreetTextController.dispose();
      _addressCityTextController.dispose();
      _addressStateTextController.dispose();
      _addressZipTextController.dispose();
      super.dispose();
    }

    final sp = context.watch<SignInProvider>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 15),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              color: Colors.black,
                              spreadRadius: .5)
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("${sp.imageUrl}"),
                        radius: 35,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  text: sp.name,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {})
                            ]),
                      ),
                      //const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: sp.email,
                          style: TextStyle(
                              color: isDark
                                  ? const Color.fromARGB(255, 206, 204, 204)
                                  : const Color.fromARGB(255, 60, 58, 58),
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              const Divider(
                thickness: 2,
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
                title: 'Profile',
                subtitle: 'View my profile',
                icon: IconlyLight.bag,
                onPressed: () {
                  _viewProfileDialog();
                },
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
                    text:
                        isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
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
                subtitle: 'Click to reset your password',
                icon: IconlyLight.unlock,
                onPressed: () {},
                color: color,
              ),
              _listTiles(
                title: 'Logout',
                subtitle: 'Contine to logout',
                icon: IconlyLight.logout,
                onPressed: () async {
                  await _logoutDialog();
                },
                color: color,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                text: 'User Id: ${sp.uid}',
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                text: 'Provider: ${sp.provider}',
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _viewProfileDialog() async {
    final sp = context.read<SignInProvider>();
    sp.getUserDataFromSharedPreferences();

    String? profilePic = sp.imageUrl;
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profilePic!),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    sp.name!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    sp.email!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    sp.provider!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Center(
                    child: Row(
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
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showAddressDialog() async {
    final sp = context.read<SignInProvider>();
    sp.getUserDataFromSharedPreferences();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Column(
              children: [
                TextField(
                  //onChanged: (value) {},
                  controller: _addressStreetTextController,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(hintText: 'Enter your address'),
                ),
                TextField(
                  //onChanged: (value) {},
                  controller: _addressCityTextController,
                  maxLines: 1,
                  decoration:
                      const InputDecoration(hintText: 'Enter your city'),
                ),
                TextField(
                  //onChanged: (value) {},
                  controller: _addressStateTextController,
                  maxLines: 1,
                  decoration:
                      const InputDecoration(hintText: 'Enter your state'),
                ),
                TextField(
                  //onChanged: (value) {},
                  controller: _addressZipTextController,
                  maxLines: 1,
                  decoration:
                      const InputDecoration(hintText: 'Enter your zip code'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    String addressStreet = _addressStreetTextController.text;
                    String addressCity = _addressCityTextController.text;
                    String addressState = _addressStateTextController.text;
                    String addressZip = _addressZipTextController.text;
                    sp.saveAddressToFirestore(
                        addressStreet, addressCity, addressState, addressZip);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
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
    final sp = context.read<SignInProvider>();

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
                    onPressed: () {
                      // logout
                      sp.userSignOut();
                      nextScreen(context, const LoginScreen());
                    },
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
