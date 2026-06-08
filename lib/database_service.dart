import '../database_helper.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

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

      // Get Device Owner
      final deviceOwner =
          FirebaseAuth.instance.currentUser?.email ?? 'Unknown Owner';

      // Get User Device Info
      String userDevice = 'Unknown Device';
      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          userDevice = '${androidInfo.brand} ${androidInfo.model}';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          userDevice = iosInfo.utsname.machine;
        }
      } catch (_) {}

      List<List<String>> csvData = [
        // CSV Headers mapping exactly to assignment requirements
        [
          'Device Owner',
          'User Details',
          'Bug/Issue',
          'User Device',
          'Description and Media Links',
        ],
      ];

      for (var f in feedbacks) {
        String userDetails =
            'Name: ${f['name']}\nEmail: ${f['email']}\nPhone: ${f['phone']}';
        String bugIssue =
            'Title: ${f['issueTitle']}\nCategory: ${f['category']}\nSeverity: ${f['severity']}';
        String descMedia =
            'Description: ${f['issueDescription']}\nAttachments: ${f['attachments']}\nProfile Pic: ${f['profilePicturePath']}';

        csvData.add([
          deviceOwner,
          userDetails,
          bugIssue,
          userDevice,
          descMedia,
        ]);
      }

      String csvString = const ListToCsvConverter().convert(csvData);

      // Save the CSV locally to the Downloads folder (Scoped Storage)
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getDownloadsDirectory();
      }

      // Fallback to documents directory if Downloads is unavailable
      directory ??= await getApplicationDocumentsDirectory();
      final path = '${directory.path}/feedback_export.csv';
      final file = File(path);
      await file.writeAsString(csvString);

      return path;
    } catch (e) {
      throw Exception('Failed to generate CSV: $e');
    }
  }
}
