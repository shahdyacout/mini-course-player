import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/course.dart';


/// العقد اللي الـ domain layer بيعتمد عليه. التنفيذ الفعلي موجود في
/// data layer (`data/repositories/course_repository_impl.dart`) — الانعكاس
/// ده هو اللي بيخلي الـ UseCases والـ Cubits تتختبر ضد نسخة وهمية
/// (fake/mock) من غير أي معرفة بـ SharedPreferences أو asset bundles.
abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses();

  Future<Either<Failure, Map<String, int>>> getAllProgress(
      List<String> courseIds);

  Future<Either<Failure, int>> getProgress(String courseId);

  Future<Either<Failure, void>> saveProgress(
      String courseId, int positionSeconds);
}