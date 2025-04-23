import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../services/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _isObscure = true;
  bool _agree = false;
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _fullName.addListener(_checkFormFilled);
    _email.addListener(_checkFormFilled);
    _password.addListener(_checkFormFilled);
    _confirmPassword.addListener(_checkFormFilled);
  }

  void _checkFormFilled() {
    final isFilled =
        _fullName.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _password.text.isNotEmpty &&
        _confirmPassword.text.isNotEmpty;

    if (isFilled != _isFormFilled) {
      setState(() {
        _isFormFilled = isFilled;
      });
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate() && _agree) {
      final user = UserModel(
        fullName: _fullName.text,
        email: _email.text,
        password: _password.text,
      );
      await DatabaseHelper().insertUser(user);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/gopresence.png',
                    height: 60,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Pendaftaran Akun",
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
                  "Silahkan isi data diri anda",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _fullName,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan Nama Lengkap',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email',
                    hintText: 'Masukkan Alamat Email',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    hintText: 'Masukkan Kata Sandi',
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                  validator:
                      (value) => value!.length < 6 ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPassword,
                  obscureText: _isObscure,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi',
                    hintText: 'Masukkan Konfirmasi Kata Sandi',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator:
                      (value) =>
                          value != _password.text
                              ? 'Passwords do not match'
                              : null,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Checkbox(
                      value: _agree,
                      onChanged: (val) => setState(() => _agree = val!),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "I agree to the ",
                          style: GoogleFonts.poppins(fontSize: 13),
                          children: [
                            TextSpan(
                              text: "Terms & Conditions & Privacy Policy",
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const TextSpan(text: " set out by this site."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _isFormFilled
                            ? _register
                            : null, // disable jika belum lengkap
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isFormFilled ? Colors.blue : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        color: _isFormFilled ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),

                // const SizedBox(height: 16),
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
                //   height: 50,
                //   child: OutlinedButton.icon(
                //     onPressed: () {},
                //     icon: Image.asset('assets/images/google.png', height: 24),
                //     label: const Text("Google"),
                //   ),
                // ),
                const SizedBox(height: 24),
                // const Spacer(),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Sudah memiliki akun? ",
                      style: GoogleFonts.poppins(),
                      children: [
                        TextSpan(
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () => Navigator.pop(context),
                          text: "Login",
                          style: GoogleFonts.poppins(color: Colors.blue),
                        ),
                      ],
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
}
