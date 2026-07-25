import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourses implements UseCase<List<Course>, NoParams> {
  final CourseRepository repository;

  GetCourses(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(NoParams params) {
    return repository.getCourses();
  }
}