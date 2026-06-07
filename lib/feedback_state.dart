abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackSuccess extends FeedbackState {}

class FeedbackLoaded extends FeedbackState {
  final List<Map<String, dynamic>> feedbacks;
  FeedbackLoaded(this.feedbacks);
}

class FeedbackDeleted extends FeedbackState {
  final int id;
  FeedbackDeleted(this.id);
}

class FeedbackError extends FeedbackState {
  final String message;
  FeedbackError(this.message);
}
