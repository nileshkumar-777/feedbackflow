class FeedbackData {
  String name = '';
  String email = '';
  String phone = '';

  String issueTitle = '';
  String issueDescription = '';
  String category = '';
  String severity = '';

  List<String> attachments = [];
  String profilePicturePath = '';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'issueTitle': issueTitle,
      'issueDescription': issueDescription,
      'category': category,
      'severity': severity,
      'profilePicturePath': profilePicturePath,
      'attachments': attachments.join(
        ',',
      ), // Convert list to string for storage
    };
  }
}
