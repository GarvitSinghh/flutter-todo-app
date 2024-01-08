import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/user_model.dart';
import 'package:flutter_todo/screens/todo_screen.dart';
import 'package:flutter_todo/utils/api_service.dart';
import 'package:flutter_todo/utils/http_service.dart';
import 'package:flutter_todo/utils/snackbar.dart';
import 'dart:math' as math;
import 'package:flutter_todo/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for Text Fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Service to call requests.
  final ApiService service = HttpService();

  // Initial states for Password Visibility and Login Loader. 
  bool _passwordVisible = true;
  bool _loggingIn = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double scaleFactor = queryData.size.height / 820;
    double scaleWidthFactor = queryData.size.width / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // Symbols in Background
            Positioned(
              top: 150,
              left: -20,
              child: Transform.rotate(
                angle: -math.pi / 4,
                child: Container(
                  height: scaleFactor * 75,
                  width: scaleFactor * 75,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withAlpha(15),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 150,
              child: Container(
                height: scaleFactor * 90,
                width: scaleFactor * 90,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withAlpha(15),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0))),
              ),
            ),
            Positioned(
              top: 350,
              right: -25,
              child: Container(
                height: scaleFactor * 90,
                width: scaleFactor * 90,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withAlpha(15),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0))),
              ),
            ),
            Positioned(
              top: 335,
              left: 45,
              child: Container(
                height: scaleFactor * 25,
                width: scaleWidthFactor * 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withAlpha(15),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: scaleFactor * 32, horizontal: scaleFactor * 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios, size: 18.0),
                        Text(
                          "Back",
                          style: TextStyle(fontSize: scaleFactor * 18.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleFactor * 32.0),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: scaleFactor * 26.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: scaleFactor * 8.0),
                        Text(
                          "We’re so excited to see you again!",
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaleFactor * 30),
                  Text(
                    "ACCOUNT INFORMATION",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor,
                      fontSize: scaleFactor * 12.0,
                    ),
                  ),
                  SizedBox(height: scaleFactor * 12.0),
                  // Username Text Field
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: scaleFactor * 16.0,
                        vertical: scaleFactor * 12.5,
                      ),
                      fillColor: Theme.of(context).hintColor.withAlpha(50),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Username",
                      hintStyle: const TextStyle(),
                    ),
                  ),
                  SizedBox(height: scaleFactor * 12.0),
                  // Password Text Field
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: scaleFactor * 16.0,
                        vertical: scaleFactor * 12.5,
                      ),
                      fillColor: Theme.of(context).hintColor.withAlpha(50),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Handle Hide and Show Passowrd
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _passwordVisible,
                  ),
                  SizedBox(height: scaleFactor * 12.0),
                  Text(
                    "Forgot your password?",
                    style: TextStyle(
                        color: Colors.blue, fontSize: scaleFactor * 12.0),
                  ),
                  SizedBox(height: scaleFactor * 12.0),
                  CustomButton(
                    text: "Login",
                    color: Theme.of(context).primaryColor,
                    onpress: _handleLogin,
                    loading: _loggingIn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Login
  void _handleLogin() async {
    setState(() {
      _loggingIn = true;
    });
    if (_usernameController.text.isEmpty) {
      showSnackBar(context, "Username cannot be Empty!");
    } else if (_passwordController.text.isEmpty) {
      showSnackBar(context, "Enter your Password!");
    } else {
      Map<String, String> body = {
        'username': _usernameController.text,
        'password': _passwordController.text
      };
      NavigatorState navigator = Navigator.of(context);
      BuildContext ctx = context;
      print("here");
      final response = await service.post(path: "/auth/login", body: body);
      print(response.body);
      if (json
          .decode(response.body)["message"]
          .toString()
          .contains("Invalid")) {
        // ignore: use_build_context_synchronously
        showSnackBar(ctx, json.decode(response.body)["message"].toString());
      } else {
        User user = User.fromJson(json.decode(response.body));
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TodoScreen(userId: user.id)),
          (route) => false,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('id');
        await prefs.setInt('id', user.id);
      }
    }
    _passwordController.text = "";
    setState(
      () {
        _loggingIn = false;
      },
    );
  }
}
