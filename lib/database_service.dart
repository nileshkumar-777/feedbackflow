import '../database_helper.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

/// Service layer that interacts with the raw SQLite DatabaseHelper
class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Submits a new feedback entry
  Future<void> submitFeedback(Map<String, dynamic> feedbackMap) async {
    await _dbHelper.insertFeedback(feedbackMap);
  }

  // Loads all stored feedback entries
  Future<List<Map<String, dynamic>>> loadFeedbacks() async {
    return await _dbHelper.queryAllRows();
  }

  // Deletes a specific feedback entry by ID
  Future<void> deleteFeedback(int id) async {
    await _dbHelper.deleteFeedback(id);
  }

  // Exports all feedback entries to a local CSV file
  Future<String?> exportFeedbacksToCSV() async {
    try {
      final feedbacks = await loadFeedbacks();
      if (feedbacks.isEmpty) return null; // Gracefully handle empty database

      List<List<String>> csvData = [
        // CSV Headers
        [
          'Name',
          'Email',
          'Phone Number',
          'Bug Title',
          'Category',
          'Severity',
          'Description',
          'Media Paths',
          'Created At',
        ],
      ];

      for (var f in feedbacks) {
        csvData.add([
          f['name']?.toString() ?? '',
          f['email']?.toString() ?? '',
          f['phone']?.toString() ?? '',
          f['issueTitle']?.toString() ?? '',
          f['category']?.toString() ?? '',
          f['severity']?.toString() ?? '',
          f['issueDescription']?.toString() ?? '',
          f['attachments']?.toString() ?? '',
          f['createdAt']?.toString() ?? '', // Extracted safely if added later
        ]);
      }

      String csvString = const ListToCsvConverter().convert(csvData);

      // Save the CSV locally on the device
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/feedback_export.csv';
      final file = File(path);
      await file.writeAsString(csvString);

      return path;
    } catch (e) {
      throw Exception('Failed to generate CSV: $e');
    }
  }
}
