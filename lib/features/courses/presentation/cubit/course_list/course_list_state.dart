import 'package:equatable/equatable.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/services/progress_calculator.dart';

abstract class CourseListState extends Equatable {
  const CourseListState();

  @override
  List<Object?> get props => [];
}

class CourseListInitial extends CourseListState {
  const CourseListInitial();
}

class CourseListLoading extends CourseListState {
  const CourseListLoading();
}

class CourseListLoaded extends CourseListState {
  final List<Course> courses;
  final Map<String, int> progressSeconds; // courseId -> ثواني محفوظة

  const CourseListLoaded({
    required this.courses,
    required this.progressSeconds,
  });

  /// دالة مساعدة للـ View: بترجع نسبة 0.0-1.0 لكورس معين.
  double progressFractionFor(Course course) {
    final saved = progressSeconds[course.id] ?? 0;
    return ProgressCalculator.progressFraction(saved, course.durationSeconds);
  }

  @override
  List<Object?> get props => [courses, progressSeconds];
}

class CourseListError extends CourseListState {
  final String message;
  const CourseListError(this.message);

  @override
  List<Object?> get props => [message];
}