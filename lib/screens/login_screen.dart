import 'package:ecib/provider/sign_in_provider.dart';
import 'package:ecib/screens/btm_bar.dart';
import 'package:ecib/screens/phone_auth_screen.dart';
import 'package:ecib/utils/config.dart';
import 'package:ecib/utils/next_screen.dart';
import 'package:ecib/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';
import '../provider/internet_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController appleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 90,
            bottom: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage(Config.app_icon),
                      height: 160,
                      width: 175,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Welcome to Essajee Carimjee Insurance Brokers (Pvt) Ltd",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Sign up or Login below:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Color.fromARGB(255, 188, 184, 184)
                            : Color.fromARGB(255, 99, 98, 98),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google login button
                  RoundedLoadingButton(
                    controller: googleController,
                    onPressed: () {
                      handleGoogleSignIn();
                    },
                    color: const Color.fromARGB(201, 5, 172, 130),
                    successColor: Colors.green,
                    width: MediaQuery.of(context).size.width * 0.8,
                    elevation: 0,
                    borderRadius: 25,
                    errorColor: Colors.red,
                    child: Wrap(
                      children: const [
                        Icon(
                          FontAwesomeIcons.google,
                          size: 20,
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Apple login button
                  RoundedLoadingButton(
                    controller: appleController,
                    onPressed: () {},
                    color: const Color.fromARGB(199, 19, 125, 146),
                    successColor: Colors.green,
                    width: MediaQuery.of(context).size.width * 0.8,
                    elevation: 0,
                    borderRadius: 25,
                    errorColor: Colors.red,
                    child: Wrap(
                      children: const [
                        Icon(
                          FontAwesomeIcons.apple,
                          size: 20,
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Text(
                          "Sign in with Apple",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedLoadingButton(
                    onPressed: () {
                      nextScreenReplace(context, const PhoneAuthScreen());
                      phoneController.reset();
                    },
                    controller: phoneController,
                    successColor: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    color: Colors.black,
                    child: Wrap(
                      children: const [
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Sign in with Phone",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // handling google sign in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();

    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "Check your internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWihGoogle().then(
        (value) {
          if (sp.hasError == 'true') {
            openSnackBar(context, sp.errorCode.toString(), Colors.red);
            googleController.reset();
          } else {
            // check if user exists
            sp.checkUserExists().then(
              (value) async {
                if (value == 'true') {
                  // user exists
                  await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                      .saveDataToSharedPreferences()
                      .then((value) => sp.setSignIn().then((value) {
                            googleController.success();
                            handleAfterSignIn();
                          })));
                } else {
                  // user does not exist
                  sp.saveDataToFirestore().then((value) => sp
                      .saveDataToSharedPreferences()
                      .then((value) => sp.setSignIn().then((value) {
                            googleController.success();
                            handleAfterSignIn();
                          })));
                }
              },
            );
          }
        },
      );
    }
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const BottomBarScreen());
    });
  }
}
