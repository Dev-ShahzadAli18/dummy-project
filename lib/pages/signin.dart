import 'package:dummy_project/pages/Home.dart';
import 'package:dummy_project/pages/Navigation.dart';
import 'package:dummy_project/pages/admin.dart';
import 'package:dummy_project/services/loginservice.dart';
import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/widgets/textfield.dart';
import 'package:dummy_project/widgets/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String selectedRole = "User";
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isloading = false;
  final _key = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                customIconButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.arrow_back,
                ),
                SizedBox(height: 50),

                Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Start you journey with JonStore",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),

                SizedBox(height: 30),

                customTextField(
                  hint: "Your Name",
                  label: "Name",
                  prefixicon: Icon(Icons.person),
                  controller: nameController,
                  validator: nameValidation,
                ),
                SizedBox(height: 15),
                customTextField(
                  hint: "Email",
                  label: "Email",
                  prefixicon: Icon(Icons.email),
                  controller: emailController,
                  validator: emailValidation,
                ),
                SizedBox(height: 15),
                customTextField(
                  hint: "Phone Number",
                  label: "Phone Number",
                  prefixicon: Icon(Icons.phone),
                  controller: phoneController,
                  validator: phoneValidation,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 15),
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
                SizedBox(height: 15),
                customTextField(
                  hint: "Confirm Password",
                  label: "Confirm Password",
                  controller: cpasswordController,
                  prefixicon: Icon(Icons.lock),
                  validator: (value) {
                    return confirmPasswordValidation(
                      value,
                      passwordController.text,
                    );
                  },
                  suffixicon: IconButton(
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword = !hideConfirmPassword;
                      });
                    },
                    icon: Icon(
                      hideConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Role",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  initialValue: selectedRole,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                  focusColor: Colors.black,

                  items: [
                    DropdownMenuItem(value: "User", child: Text("User")),
                    DropdownMenuItem(
                      // ignore: sort_child_properties_last
                      child: Text("Admin"),
                      value: "Admin",
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                SizedBox(height: 25),
                customButton(
                  text: "Sign Up",
                  onTap: () {
                    if (_key.currentState!.validate()) {
                      createaccount(
                        nameController.text.trim().toString(),
                        emailController.text.trim().toString(),
                        passwordController.text.trim().toString(),
                        passwordController.text.trim().toString(),
                        selectedRole,
                        phoneController.text.trim(),
                      );
                    }
                    if (selectedRole == "Admin") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AdminPage()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainNavigation(),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
