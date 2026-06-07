import 'package:flutter/material.dart';
import 'package:feedback_flow/feedback_data.dart';

class StepFourScreen extends StatelessWidget {
  final FeedbackData feedbackData;
  const StepFourScreen({super.key, required this.feedbackData});

  @override
  Widget build(BuildContext context) {
    return ReviewFeedbackScreen(feedbackData: feedbackData);
  }
}

class ReviewFeedbackScreen extends StatelessWidget {
  final FeedbackData feedbackData;
  const ReviewFeedbackScreen({Key? key, required this.feedbackData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          const Center(
            child: Text(
              'Review Your Feedback',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Please verify all details before submitting.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // 1. User Information Card
          _buildReviewCard(
            icon: Icons.person_outline,
            title: 'USER INFORMATION',
            onEditPressed: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedbackData.name.isNotEmpty
                      ? feedbackData.name
                      : 'Unknown User',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  feedbackData.email.isNotEmpty
                      ? feedbackData.email
                      : 'No email provided',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feedbackData.phone.isNotEmpty
                      ? feedbackData.phone
                      : 'No phone provided',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Issue Details Card
          _buildReviewCard(
            icon: Icons.description_outlined,
            title: 'ISSUE DETAILS',
            onEditPressed: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        feedbackData.issueTitle.isNotEmpty
                            ? feedbackData.issueTitle
                            : 'No Title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Critical Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff8B0000).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff8B0000).withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 6,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            feedbackData.severity.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Category
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13),
                    children: [
                      TextSpan(
                        text: 'Category: ',
                        style: TextStyle(
                          color: Colors.orangeAccent.withOpacity(0.7),
                        ),
                      ),
                      TextSpan(
                        text: feedbackData.category.isNotEmpty
                            ? feedbackData.category
                            : 'None',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Inner Quote/Description Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Text(
                    '"${feedbackData.issueDescription.isNotEmpty ? feedbackData.issueDescription : 'No description provided.'}"',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Attached Media Card
          _buildReviewCard(
            icon: Icons.perm_media_outlined,
            title: 'ATTACHED MEDIA (${feedbackData.attachments.length})',
            onEditPressed: () {},
            child: feedbackData.attachments.isEmpty
                ? Text(
                    'No media attached.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: feedbackData.attachments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: SizedBox(
                            width: 120,
                            child: _buildMediaThumbnail(
                              fileName: feedbackData.attachments[index],
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff1A1B26),
                                      Color(0xff0F2027),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.insert_drive_file,
                                    size: 28,
                                    color: Colors.blueGrey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Helper template structure to generate identical dark block cards
  Widget _buildReviewCard({
    required IconData icon,
    required String title,
    required VoidCallback onEditPressed,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1A1B26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header block
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.white.withOpacity(0.6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              TextButton(
                onPressed: onEditPressed,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Component structure for individual preview attachments
  Widget _buildMediaThumbnail({
    required String fileName,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Positioned.fill(child: child),
          // Dark bottom bar to hold file metadata text neatly
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.black.withOpacity(0.6),
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
