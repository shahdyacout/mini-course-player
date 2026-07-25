import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/course.dart';
import '../../../../injection_container.dart';
import '../cubit/course_player/course_player_cubit.dart';
import '../cubit/course_player/course_player_state.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final di = context.read<InjectionContainer>();

    return BlocProvider(
      create: (_) => CoursePlayerCubit(
        courseId: course.id,
        videoUrl: course.videoUrl,
        durationSeconds: course.durationSeconds,
        getProgress: di.getProgress,
        saveProgress: di.saveProgress,
        networkInfo: di.networkInfo,
      )..initialize(),
      child: _CourseDetailView(course: course),
    );
  }
}

class _CourseDetailView extends StatelessWidget {
  final Course course;
  const _CourseDetailView({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BlocBuilder<CoursePlayerCubit, CoursePlayerState>(
                builder: (context, state) => _PlayerArea(state: state),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(course.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerArea extends StatelessWidget {
  final CoursePlayerState state;
  const _PlayerArea({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is CoursePlayerCheckingConnection || state is CoursePlayerLoading) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (state is CoursePlayerOffline) {
      return _MessageOverlay(
        icon: Icons.wifi_off,
        message: 'No internet connection.\nCheck your connection and try again.',
        onRetry: () => context.read<CoursePlayerCubit>().retry(),
      );
    }

    if (state is CoursePlayerFailed) {
      return _MessageOverlay(
        icon: Icons.error_outline,
        message: (state as CoursePlayerFailed).message,
        onRetry: () => context.read<CoursePlayerCubit>().retry(),
      );
    }

    final controller = (state as CoursePlayerReady).controller;
    return GestureDetector(
      onTap: () => context.read<CoursePlayerCubit>().togglePlayPause(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(controller),
          ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return value.isPlaying
                  ? const SizedBox.shrink()
                  : const Icon(Icons.play_arrow, size: 56, color: Colors.white70);
            },
          ),
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(playedColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class _MessageOverlay extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  const _MessageOverlay({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white70, size: 40),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}