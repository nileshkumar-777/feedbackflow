import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:feedback_flow/feedback_data.dart';

class StepOneScreen extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final FeedbackData feedbackData;

  const StepOneScreen({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.feedbackData,
  });

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF13131A),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'User Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Tell us a little about yourself before submitting feedback.',
            style: TextStyle(fontSize: 14, color: Colors.white60, height: 1.4),
          ),

          const SizedBox(height: 30),

          Center(
            child: GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );
                if (result != null && result.files.single.path != null) {
                  setState(() {
                    widget.feedbackData.profilePicturePath =
                        result.files.single.path!;
                  });
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x227B88FF),
                          blurRadius: 25,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFF2C2C35),
                      backgroundImage:
                          widget.feedbackData.profilePicturePath.isNotEmpty
                          ? FileImage(
                              File(widget.feedbackData.profilePicturePath),
                            )
                          : null,
                      child: widget.feedbackData.profilePicturePath.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white54,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6A6B7A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(
                  controller: widget.nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: widget.emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: widget.phoneController,
                  label: 'Phone Number',
                  hint: '+91 XXXXXXXXXX',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const Spacer(),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Your data is securely stored and encrypted. We never share your details with third parties.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white38,
                      height: 1.5,
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 15),
            prefixIcon: Icon(icon, color: Colors.white54, size: 22),
            filled: true,
            fillColor: const Color(0xFF2C2C35),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
