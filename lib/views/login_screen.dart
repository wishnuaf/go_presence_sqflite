import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_presence_sqflite/views/home_screen.dart';
import 'package:go_presence_sqflite/views/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  'assets/images/gopresence.png', // Ganti dengan path ikon kamu
                  height: 60,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Selamat Datang 👋",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "di ",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Go Presence",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Silahkan login ke aplikasi",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Alamat Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 24),
              // Row(
              //   children: [
              //     const Expanded(child: Divider()),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8),
              //       child: Text(
              //         "Or continue with social account",
              //         style: GoogleFonts.poppins(fontSize: 12),
              //       ),
              //     ),
              //     const Expanded(child: Divider()),
              //   ],
              // ),
              // const SizedBox(height: 16),
              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: OutlinedButton.icon(
              //     icon: Image.asset(
              //       'assets/images/google.png', // Ganti dengan ikon Google
              //       height: 24,
              //     ),
              //     onPressed: () {},
              //     label: Text(
              //       'Google',
              //       style: GoogleFonts.poppins(
              //         fontSize: 16,
              //         color: Colors.black87,
              //       ),
              //     ),
              //     style: OutlinedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //   ),
              // ),
              const Spacer(),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "Belum memiliki akun? ",
                    style: GoogleFonts.poppins(),
                    children: [
                      TextSpan(
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                        text: "Daftar",
                        style: GoogleFonts.poppins(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
