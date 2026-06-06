import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:feedback_flow/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();

    _googleSignIn.initialize(
      serverClientId:
          '265135151280-h9kacv6eirbin4co0u2c3ks5s8n4qus6.apps.googleusercontent.com',
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(userName: "Nilesh"),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    if (_isGoogleLoading) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final displayName = userCredential.user?.displayName ?? "User";

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userName: displayName),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    required IconData icon,
    required Color fillColor,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: fillColor,
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white24),
      prefixIcon: Icon(icon, color: Colors.white38),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF111827);
    const cardColor = Color(0xFF1F2937);
    const fieldColor = Color(0xFF2C3446);
    const accentColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const _FeedbackLogo(),

                    const SizedBox(height: 20),

                    const Text(
                      "Feedback Flow",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: _fieldDecoration(
                              hintText: "Email",
                              icon: Icons.email,
                              fillColor: fieldColor,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Email";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: _fieldDecoration(
                              hintText: "Password",
                              icon: Icons.lock,
                              fillColor: fieldColor,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return "Minimum 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25),

                          FilledButton(
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: accentColor,
                              minimumSize: const Size.fromHeight(55),
                            ),
                            child: const Text("Login"),
                          ),

                          const SizedBox(height: 15),

                          FilledButton.icon(
                            onPressed: _isGoogleLoading
                                ? null
                                : _signInWithGoogle,
                            icon: _isGoogleLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                            label: Text(
                              _isGoogleLoading
                                  ? "Signing In..."
                                  : "Sign In With Google",
                              style: const TextStyle(color: Colors.black),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackLogo extends StatelessWidget {
  const _FeedbackLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
        ),
      ),
      child: const Icon(Icons.chat, color: Colors.white, size: 50),
    );
  }
}
