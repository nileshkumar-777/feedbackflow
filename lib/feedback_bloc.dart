import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';
import 'database_service.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final DatabaseService databaseService;

  FeedbackBloc({required this.databaseService}) : super(FeedbackInitial()) {
    on<SubmitFeedback>(_onSubmitFeedback);
    on<LoadFeedbacks>(_onLoadFeedbacks);
    on<DeleteFeedback>(_onDeleteFeedback);
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      await databaseService.submitFeedback(event.feedback.toMap());
      emit(FeedbackSuccess());
    } catch (e) {
      emit(FeedbackError('Failed to submit feedback: $e'));
    }
  }

  Future<void> _onLoadFeedbacks(
    LoadFeedbacks event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      final feedbacks = await databaseService.loadFeedbacks();
      emit(FeedbackLoaded(feedbacks));
    } catch (e) {
      emit(FeedbackError('Failed to load feedbacks: $e'));
    }
  }

  Future<void> _onDeleteFeedback(
    DeleteFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      await databaseService.deleteFeedback(event.id);
      emit(FeedbackDeleted(event.id));
      add(LoadFeedbacks()); // Refresh the feedback list after deletion
    } catch (e) {
      emit(FeedbackError('Failed to delete feedback: $e'));
    }
  }
}
