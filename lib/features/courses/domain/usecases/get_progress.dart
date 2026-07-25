import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';

class GetProgressParams extends Equatable {
  final String courseId;
  const GetProgressParams(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class GetProgress implements UseCase<int, GetProgressParams> {
  final CourseRepository repository;

  GetProgress(this.repository);

  @override
  Future<Either<Failure, int>> call(GetProgressParams params) {
    return repository.getProgress(params.courseId);
  }
}