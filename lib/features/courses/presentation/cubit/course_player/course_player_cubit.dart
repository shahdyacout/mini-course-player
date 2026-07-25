import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/services/progress_calculator.dart';
import '../../../domain/usecases/get_progress.dart';
import '../../../domain/usecases/save_progress.dart';
import 'course_player_state.dart';

class CoursePlayerCubit extends Cubit<CoursePlayerState> {
  final String courseId;
  final String videoUrl;
  final int durationSeconds;

  final GetProgress getProgress;
  final SaveProgress saveProgress;
  final NetworkInfo networkInfo;

  Timer? _saveTimer;
  VideoPlayerController? _controller;

  CoursePlayerCubit({
    required this.courseId,
    required this.videoUrl,
    required this.durationSeconds,
    required this.getProgress,
    required this.saveProgress,
    required this.networkInfo,
  }) : super(const CoursePlayerCheckingConnection());

  Future<void> initialize() async {
    emit(const CoursePlayerCheckingConnection());

    if (!await networkInfo.isConnected) {
      emit(const CoursePlayerOffline());
      return;
    }

    await _setupPlayer();
  }

  Future<void> _setupPlayer() async {
    emit(const CoursePlayerLoading());
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Video load timed out'),
      );

      final progressResult = await getProgress(GetProgressParams(courseId));
      final savedSeconds = progressResult.fold((_) => 0, (seconds) => seconds);
      final resumeAt = ProgressCalculator.resumePositionSeconds(
        savedSeconds,
        durationSeconds,
      );
      if (resumeAt > 0) {
        await controller.seekTo(Duration(seconds: resumeAt));
      }

      _controller = controller;
      await controller.play();

      _saveTimer = Timer.periodic(
        const Duration(seconds: 3),
            (_) => _persistCurrentPosition(),
      );

      emit(CoursePlayerReady(controller));
    } catch (_) {
      emit(const CoursePlayerFailed('This video could not be played.'));
    }
  }

  Future<void> retry() => initialize();

  void togglePlayPause() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  Future<void> _persistCurrentPosition() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final position = controller.value.position.inSeconds;
    await saveProgress(SaveProgressParams(courseId, position));
  }

  @override
  Future<void> close() async {
    _saveTimer?.cancel();
    await _persistCurrentPosition();
    await _controller?.dispose();
    return super.close();
  }
}