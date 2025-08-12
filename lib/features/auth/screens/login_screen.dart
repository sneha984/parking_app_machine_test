import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_app_machine_test/core/commons/snackbar.dart';
import 'package:parking_app_machine_test/theme/palette.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../controller/auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    final success = await ref.read(authControllerProvider.notifier).login(
          _mobileController.text.trim(),
          _passwordController.text.trim(),
        );
    setState(() => _loading = false);

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/vehicles');
    } else {
      showPrimarySnackBar(context, "Login Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Palette.primaryColor, Palette.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    size: width * 0.27,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'LOGIN',
                  style: GoogleFonts.urbanist(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Palette.whiteColor,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: height * 0.003),
                Text(
                  'ACCOUNT',
                  style: GoogleFonts.urbanist(
                    fontSize: height * 0.02,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: height * 0.045),
                _buildTextField(_mobileController, 'Mobile', false),
                SizedBox(height: height * 0.02),
                _buildTextField(_passwordController, 'Password', true),
                SizedBox(height: height * 0.07),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD64545),
                      padding: EdgeInsets.symmetric(vertical: height * 0.016),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Palette.whiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'LOGIN',
                            style: GoogleFonts.urbanist(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.urbanist(color: Palette.whiteColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        filled: true,
        fillColor: Palette.blackColor.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
