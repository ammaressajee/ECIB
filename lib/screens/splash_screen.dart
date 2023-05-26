import 'dart:async';

import 'package:ecib/provider/sign_in_provider.dart';
import 'package:ecib/screens/btm_bar.dart';
import 'package:ecib/screens/login_screen.dart';
import 'package:ecib/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
// init state
  @override
  void initState() {
    final sb = context.read<SignInProvider>();
    super.initState();

    // create a 2 second timer
    Timer(const Duration(seconds: 2), () {
      sb.isSignedIn == false
          ? nextScreen(context, const LoginScreen())
          : nextScreen(context, const BottomBarScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Image(
            image: AssetImage(Config.app_icon),
            height: 80,
            width: 80,
          ),
        ),
      ),
    );
  }
}
