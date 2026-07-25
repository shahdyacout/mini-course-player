import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_all_progress.dart';
import '../../../domain/usecases/get_courses.dart';
import 'course_list_state.dart';

/// ViewModel لشاشة قائمة الكورسات. بينسق بين الـ UseCases وبيطلع
/// CourseListState للـ View — مالوش أي معرفة بـ SharedPreferences
/// أو JSON أو connectivity plugins.
class CourseListCubit extends Cubit<CourseListState> {
  final GetCourses getCourses;
  final GetAllProgress getAllProgress;

  CourseListCubit({
    required this.getCourses,
    required this.getAllProgress,
  }) : super(const CourseListInitial());

  Future<void> loadCourses() async {
    emit(const CourseListLoading());

    final coursesResult = await getCourses(const NoParams());

    await coursesResult.fold(
          (failure) async => emit(CourseListError(_messageFor(failure))),
          (courses) async {
        final progressResult = await getAllProgress(
          GetAllProgressParams(courses.map((c) => c.id).toList()),
        );
        progressResult.fold(
              (failure) => emit(CourseListError(_messageFor(failure))),
              (progressMap) => emit(CourseListLoaded(
            courses: courses,
            progressSeconds: progressMap,
          )),
        );
      },
    );
  }

  String _messageFor(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Check your connection and try again.';
    }
    return failure.message;
  }
}