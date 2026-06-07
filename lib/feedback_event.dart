import '../feedback_data.dart';

abstract class FeedbackEvent {}

class SubmitFeedback extends FeedbackEvent {
  final FeedbackData feedback;
  SubmitFeedback(this.feedback);
}

class LoadFeedbacks extends FeedbackEvent {}

class DeleteFeedback extends FeedbackEvent {
  final int id;
  DeleteFeedback(this.id);
}
