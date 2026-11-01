import 'package:dummy_project/pages/sign_up_page.dart';
import 'package:dummy_project/services/login_service.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/form_validators.dart';
import 'package:dummy_project/widgets/custom_text_field.dart';

import 'package:dummy_project/widgets/responsive_layout.dart';
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ResponsiveLayout.builder(
        breakpoints: ResponsiveBreakpoints(tablet: 750, tabletInclusive: false),
        builder: (context, size, constraints) {
          final isWeb = size != ResponsiveSize.mobile;
          if (isWeb) {
            return Row(
              children: [
                Expanded(
                  child: SizedBox.expand(child: _buildBranding(isWeb: true)),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 30,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 430),
                          child: _buildLoginForm(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBranding(isWeb: false),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 25,
                    ),
                    child: _buildLoginForm(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBranding({required bool isWeb}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 25 : 12,
        vertical: isWeb ? 30 : 12,
      ),
      decoration: BoxDecoration(color: Color.fromARGB(255, 23, 23, 23)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -70,
            left: -60,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            right: -60,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: isWeb ? 95 : 48,
                width: isWeb ? 95 : 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isWeb ? 24 : 14),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.black,
                  size: isWeb ? 48 : 28,
                ),
              ),

              SizedBox(height: isWeb ? 22 : 8),

              Text(
                'JONSTORE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isWeb ? 36 : 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: isWeb ? 3 : 2,
                ),
              ),

              SizedBox(height: isWeb ? 12 : 5),

              Text(
                'YOUR STYLE, YOUR STORE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 193, 7),
                  fontSize: isWeb ? 13 : 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isWeb ? 2 : 1,
                ),
              ),

              if (isWeb) ...[
                SizedBox(height: 22),

                Text(
                  'Discover your style.\nShop your favourite things.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.7,
                  ),
                ),

                SizedBox(height: 25),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      color: Color.fromARGB(255, 255, 193, 7),
                      size: 22,
                    ),
                    Text(
                      'Easy Shopping • Great Style',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'Login to continue shopping with JONSTORE.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),

          SizedBox(height: 35),

          customTextField(
            hint: 'Enter your email',
            label: 'Email',
            prefixicon: Icon(Icons.email_outlined),
            controller: emailController,
            validator: emailValidation,
          ),

          SizedBox(height: 18),

          customTextField(
            hint: 'Enter your password',
            label: 'Password',
            prefixicon: Icon(Icons.lock_outline),
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

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: customButton(
              text: 'Login',
              onTap: () {
                if (_Key.currentState?.validate() ?? false) {
                  login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    context,
                  );
                }
              },
            ),
          ),

          SizedBox(height: 25),

          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signin()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
