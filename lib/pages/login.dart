import 'package:dummy_project/pages/signin.dart';
import 'package:dummy_project/services/loginservice.dart' hide Signin;
import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/widgets/textfield.dart';
import 'package:dummy_project/widgets/validation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _Key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _Key,
            child: Column(
              children: [
                SizedBox(height: 150),
                Text(
                  "Login Page",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "Welcome Back to JonStore...!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 30),
                customTextField(
                  hint: "Email",
                  label: "Email",
                  prefixicon: Icon(Icons.email),
                  controller: emailController,
                  validator: emailValidation,
                ),
                SizedBox(height: 10),
                customTextField(
                  hint: "Password",
                  label: "Password",
                  prefixicon: Icon(Icons.lock),
                  controller: passwordController,
                  obscureText: hidePassword,
                  validator: passwordValidation,
                  suffixicon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    "Forget Password",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: 30),
                customButton(
                  text: "Login",
                  onTap: () {
                    if (_Key.currentState!.validate()) {
                      login(
                        emailController.text.trim().toString(),
                        passwordController.text.trim().toString(),
                        context,
                      );
                    }
                  },
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      "Don't have an account.?",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signin()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
