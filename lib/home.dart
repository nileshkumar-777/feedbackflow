import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_data.dart';
import 'feedback_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';
import 'screens/s1.dart';
import 'screens/s2.dart';
import 'screens/s3.dart';
import 'screens/s4.dart';
import 'screens/thanks.dart';
import 'database_helper.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int currentStep = 1;

  final FeedbackData feedbackData = FeedbackData();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> nextStep() async {
    // Save Step 1 Data
    if (currentStep == 1) {
      feedbackData.name = nameController.text.trim();
      feedbackData.email = emailController.text.trim();
      feedbackData.phone = phoneController.text.trim();
    }

    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    } else {
      // Dispatch the SubmitFeedback event to the BLoC
      context.read<FeedbackBloc>().add(SubmitFeedback(feedbackData));
    }
  }

  Widget getStepContent() {
    switch (currentStep) {
      case 1:
        return StepOneScreen(
          nameController: nameController,
          emailController: emailController,
          phoneController: phoneController,
          feedbackData: feedbackData,
        );

      case 2:
        return StepTwoScreen(feedbackData: feedbackData);

      case 3:
        return StepThreeScreen(feedbackData: feedbackData);

      case 4:
        return StepFourScreen(feedbackData: feedbackData);

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ThankYouScreen()),
          );
        } else if (state is FeedbackError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF13131A),
          body: SafeArea(
            child: Column(
              children: [
                // Animated Progress Bar Indicator
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 8,
                  ),
                  child: Row(
                    children: List.generate(4, (index) {
                      final stepNumber = index + 1;
                      final isActive = currentStep >= stepNumber;
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF6366F1)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF6366F1,
                                      ).withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Current Step Form Content with smooth AnimatedSwitcher
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.05, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                    child: KeyedSubtree(
                      key: ValueKey<int>(currentStep),
                      child: getStepContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: state is FeedbackLoading ? null : nextStep,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.30),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is FeedbackLoading && currentStep == 4)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      else ...[
                        Text(
                          currentStep == 4 ? "Submit Feedback" : "Continue",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.3);
      },
    );
  }
}
