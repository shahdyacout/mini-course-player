import 'package:equatable/equatable.dart';

/// Entity نضيف تمامًا — عن قصد مفيهاش `fromJson`/`toJson`، لأن دي
/// تفاصيل تخص طبقة الـ data (شوفي `data/models/course_model.dart`).
/// الـ domain layer المفروض ميعرفش إن الـ JSON موجود من الأساس.
class Course extends Equatable {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int durationSeconds;
  final String description;
  final String videoUrl;

  const Course({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.description,
    required this.videoUrl,
  });

  @override
  List<Object?> get props =>
      [id, title, thumbnailUrl, durationSeconds, description, videoUrl];
}