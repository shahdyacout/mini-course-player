import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_local_datasource.dart';
import '../datasources/progress_local_datasource.dart';



/// بينفذ عقد الـ domain (CourseRepository). ده المكان الوحيد اللي عارف
/// إن كل من DataSources والـ Failures موجودين مع بعض — كل حاجة فوقه
/// (usecases, Cubits) بتشوف بس Course entities و Failures، مش
/// Exceptions ولا JSON ولا SharedPreferences.
class CourseRepositoryImpl implements CourseRepository {
  final CourseLocalDataSource localDataSource;
  final ProgressLocalDataSource progressDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.localDataSource,
    required this.progressDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Course>>> getCourses() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final courses = await localDataSource.getCourses();
      return Right(courses);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getAllProgress(
      List<String> courseIds) async {
    try {
      final positions = await progressDataSource.getAllPositions(courseIds);
      return Right(positions);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getProgress(String courseId) async {
    try {
      final position = await progressDataSource.getPosition(courseId);
      return Right(position);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveProgress(
      String courseId, int positionSeconds) async {
    try {
      await progressDataSource.savePosition(courseId, positionSeconds);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}