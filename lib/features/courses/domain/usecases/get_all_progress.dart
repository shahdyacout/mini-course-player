import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';

class GetAllProgressParams extends Equatable {
  final List<String> courseIds;
  const GetAllProgressParams(this.courseIds);

  @override
  List<Object?> get props => [courseIds];
}

class GetAllProgress implements UseCase<Map<String, int>, GetAllProgressParams> {
  final CourseRepository repository;

  GetAllProgress(this.repository);

  @override
  Future<Either<Failure, Map<String, int>>> call(GetAllProgressParams params) {
    return repository.getAllProgress(params.courseIds);
  }
}