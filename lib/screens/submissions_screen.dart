import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedback_flow/feedback_bloc.dart';
import 'package:feedback_flow/feedback_event.dart';
import 'package:feedback_flow/feedback_state.dart';
import 'package:feedback_flow/database_service.dart';
import 'package:feedback_flow/service_locator.dart';

class SubmissionsScreen extends StatefulWidget {
  const SubmissionsScreen({super.key});

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  @override
  void initState() {
    super.initState();
    // Load feedbacks when the screen initializes
    context.read<FeedbackBloc>().add(LoadFeedbacks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Feedback',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2937),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            tooltip: 'Export as CSV',
            onPressed: () async {
              try {
                final dbService = locator<DatabaseService>();
                final path = await dbService.exportFeedbacksToCSV();

                if (!context.mounted) return;

                if (path == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No feedback entries to export.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Exported successfully to:\n$path')),
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF111827),
      body: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackDeleted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Submission deleted')));
          } else if (state is FeedbackError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is FeedbackLoading && state is! FeedbackLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FeedbackLoaded) {
            final submissions = state.feedbacks;

            if (submissions.isEmpty) {
              return const Center(
                child: Text(
                  'No feedback submitted yet.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final item = submissions[index];
                return Card(
                  color: const Color(0xFF1F2937),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      item['issueTitle'] ?? 'No Title',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'From: ${item['name']}\nCategory: ${item['category']} | Severity: ${item['severity']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white54,
                      ),
                      tooltip: 'Delete this submission',
                      onPressed: () {
                        context.read<FeedbackBloc>().add(
                          DeleteFeedback(item['id']),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
