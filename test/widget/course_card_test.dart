import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_course_player/features/courses/domain/entities/course.dart';
import 'package:mini_course_player/features/courses/presentation/widgets/course_card.dart';

void main() {
  const testCourse = Course(
    id: 'c001',
    title: 'Intro to UI/UX Design',
    thumbnailUrl: 'https://picsum.photos/seed/course1/400/225',
    durationSeconds: 30,
    description: 'A short primer on UI/UX fundamentals.',
    videoUrl: 'https://example.com/video.mp4',
  );

  testWidgets('CourseCard shows title and correct progress percentage',
          (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CourseCard(
                course: testCourse,
                progress: 0.4,
                onTap: () => tapped = true,
              ),
            ),
          ),
        );

        expect(find.text('Intro to UI/UX Design'), findsOneWidget);
        expect(find.text('40%'), findsOneWidget);

        await tester.tap(find.byType(CourseCard));
        expect(tapped, isTrue);
      });

  testWidgets('CourseCard shows 0% when there is no saved progress',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CourseCard(course: testCourse, progress: 0.0, onTap: () {}),
            ),
          ),
        );

        expect(find.text('0%'), findsOneWidget);
      });
}