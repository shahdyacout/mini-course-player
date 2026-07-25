import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

abstract class CoursePlayerState extends Equatable {
  const CoursePlayerState();

  @override
  List<Object?> get props => [];
}

class CoursePlayerCheckingConnection extends CoursePlayerState {
  const CoursePlayerCheckingConnection();
}

class CoursePlayerOffline extends CoursePlayerState {
  const CoursePlayerOffline();
}

class CoursePlayerLoading extends CoursePlayerState {
  const CoursePlayerLoading();
}

/// الفيديو جاهز للتشغيل. الـ controller نفسه هو مصدر الحقيقة لموضع
/// التشغيل/حالة التشغيل (الـ View بتستمع له مباشرة عن طريق
/// ValueListenableBuilder)، فالـ Cubit مش محتاج يطلع State جديدة كل فريم.
class CoursePlayerReady extends CoursePlayerState {
  final VideoPlayerController controller;
  const CoursePlayerReady(this.controller);

  @override
  List<Object?> get props => [controller];
}

class CoursePlayerFailed extends CoursePlayerState {
  final String message;
  const CoursePlayerFailed(this.message);

  @override
  List<Object?> get props => [message];
}