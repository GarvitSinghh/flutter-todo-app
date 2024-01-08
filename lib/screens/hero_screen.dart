import 'package:flutter/material.dart';
import 'package:flutter_todo/screens/login_screen.dart';
import 'package:flutter_todo/widgets/custom_button.dart';

// Initial Screen for Logged Out Users
class HeroScreen extends StatelessWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Variables for Responsive Design
    MediaQueryData queryData = MediaQuery.of(context);
    double scaleFactor = queryData.size.height / 820;
    double scaleWidthFactor = queryData.size.width / 375;

    return Scaffold(
      // Prevent Keyboard Overflow
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: scaleFactor * 32.0, horizontal: scaleFactor * 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Hero Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("assets/logo.png"),
                      height: 45.0,
                      width: 45.0,
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      "To-Do App",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: scaleFactor * 32,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                // Hero Illustration
                Image(
                  image: const AssetImage("assets/hero_illustration.png"),
                  width: scaleWidthFactor * 250,
                ),
                // Buttons
                const SizedBox(height: 32),
                Column(
                  children: <Widget>[
                    Text(
                      "Welcome to To-Do",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: scaleFactor * 24.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Join over 100 million people who use To-Do to keep track of their tasks and be productive.",
                      style: TextStyle(color: Theme.of(context).hintColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: <Widget>[
                    CustomButton(
                      text: "Register",
                      color: Theme.of(context).primaryColor,
                      onpress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                    SizedBox(height: scaleFactor * 15.0),
                    CustomButton(
                      text: "Log In",
                      color: Theme.of(context).hintColor,
                      onpress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
