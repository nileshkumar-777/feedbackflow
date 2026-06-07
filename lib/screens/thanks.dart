import 'package:flutter/material.dart';
import 'package:feedback_flow/screens/feedback_hub_screen.dart';
import 'package:feedback_flow/screens/submissions_screen.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  Widget _buildGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090E17), // Deep dark navy base
      body: Stack(
        children: [
          // Ambient Success Glows
          Positioned(
            top: -100,
            left: -50,
            child: _buildGlow(
              const Color(0xFF10B981),
              300,
            ), // Emerald green glow
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildGlow(const Color(0xFF6366F1), 250), // Indigo glow
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glowing Success Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        size: 100,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      "Feedback Submitted!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Thank you for helping us improve the app.\nYour insights are invaluable.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Primary Button: Return to Hub
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FeedbackHubScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shadowColor: const Color(0xFF6366F1).withOpacity(0.5),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Return to Hub",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Secondary Button: View Saved Submissions
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubmissionsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.list_alt, color: Colors.white70),
                      label: const Text(
                        'View Saved Submissions',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
