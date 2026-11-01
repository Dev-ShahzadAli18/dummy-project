import 'package:dummy_project/pages/main_navigation.dart';
import 'package:dummy_project/pages/admin_dashboard_page.dart';
import 'package:dummy_project/services/login_service.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/custom_text_field.dart';
import 'package:dummy_project/widgets/form_validators.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  int selectedAge = 18;
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
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 25,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 450),
                          child: _buildSignupForm(),
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
                    child: _buildSignupForm(),
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
      decoration: const BoxDecoration(color: Color.fromARGB(255, 23, 23, 23)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -70,
            left: -60,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            right: -60,
            child: Container(
              height: 250,
              width: 250,
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
                height: isWeb ? 75 : 48,
                width: isWeb ? 75 : 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isWeb ? 22 : 14),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.black,
                  size: isWeb ? 42 : 28,
                ),
              ),

              SizedBox(height: isWeb ? 18 : 8),

              Text(
                'JONSTORE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isWeb ? 30 : 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: isWeb ? 3 : 2,
                ),
              ),

              SizedBox(height: isWeb ? 10 : 5),

              Text(
                'YOUR STYLE, YOUR STORE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 193, 7),
                  fontSize: isWeb ? 12 : 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isWeb ? 2 : 1,
                ),
              ),

              SizedBox(height: isWeb ? 18 : 8),

              Text(
                'Create your account and discover\nyour favourite styles.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isWeb ? 14 : 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start your journey with JONSTORE.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
          SizedBox(height: 25),

          customTextField(
            hint: 'Your Name',
            label: 'Name',
            prefixicon: Icon(Icons.person_outline),
            controller: nameController,
            validator: nameValidation,
          ),
          SizedBox(height: 15),

          customTextField(
            hint: 'Enter your email',
            label: 'Email',
            prefixicon: Icon(Icons.email_outlined),
            controller: emailController,
            validator: emailValidation,
          ),
          SizedBox(height: 15),

          customTextField(
            hint: 'Phone Number',
            label: 'Phone Number',
            prefixicon: Icon(Icons.phone_outlined),
            controller: phoneController,
            validator: phoneValidation,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 15),

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
          SizedBox(height: 15),

          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cake_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Your Age',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$selectedAge years',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                Slider(
                  value: selectedAge.toDouble(),
                  min: 10,
                  max: 90,
                  divisions: 67,
                  label: '$selectedAge years',

                  activeColor: Colors.white,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (value) {
                    setState(() {
                      selectedAge = value.round();
                    });
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '10 years',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      '90 years',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          customTextField(
            hint: 'Confirm your password',
            label: 'Confirm Password',
            prefixicon: Icon(Icons.lock_outline),
            controller: cpasswordController,
            obscureText: hideConfirmPassword,
            validator: (value) {
              return confirmPasswordValidation(value, passwordController.text);
            },
            suffixicon: IconButton(
              onPressed: () {
                setState(() {
                  hideConfirmPassword = !hideConfirmPassword;
                });
              },
              icon: Icon(
                hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          SizedBox(height: 18),

          Text(
            'Role',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          DropdownButtonFormField<String>(
            initialValue: selectedRole,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              DropdownMenuItem(value: 'User', child: Text('User')),
              DropdownMenuItem(value: 'Admin', child: Text('Admin')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedRole = value;
                });
              }
            },
          ),

          SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: customButton(
              text: isloading ? 'Creating Account...' : 'Sign Up',
              onTap: () async {
                if (isloading) return;

                if (!(_key.currentState?.validate() ?? false)) {
                  return;
                }

                setState(() {
                  isloading = true;
                });

                try {
                  await createaccount(
                    nameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    cpasswordController.text.trim(),
                    selectedRole,
                    phoneController.text.trim(),
                    selectedAge,
                  );

                  if (!mounted) return;

                  if (selectedRole == 'Admin') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPage()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainNavigation()),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account creation failed: $e')),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      isloading = false;
                    });
                  }
                }
              },
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
