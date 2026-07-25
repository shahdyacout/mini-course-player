import 'package:equatable/equatable.dart';

/// الأساس اللي كل أنواع الـ Failures بترث منه. بتتحول لـ Left جوه
/// Either`<Failure, T>` بدل ما نرمي Exception خام للطبقات العليا.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not load local data.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class PlaybackFailure extends Failure {
  const PlaybackFailure([super.message = 'The video could not be played.']);
}