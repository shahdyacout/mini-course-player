import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';

class SaveProgressParams extends Equatable {
  final String courseId;
  final int positionSeconds;
  const SaveProgressParams(this.courseId, this.positionSeconds);

  @override
  List<Object?> get props => [courseId, positionSeconds];
}

class SaveProgress implements UseCase<void, SaveProgressParams> {
  final CourseRepository repository;

  SaveProgress(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveProgressParams params) {
    return repository.saveProgress(params.courseId, params.positionSeconds);
  }
}
