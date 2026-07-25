import 'package:flutter_test/flutter_test.dart';
import 'package:mini_course_player/features/courses/domain/services/progress_calculator.dart';

void main() {
  group('ProgressCalculator.progressFraction', () {
    test('returns 0 when nothing watched', () {
      expect(ProgressCalculator.progressFraction(0, 120), 0.0);
    });

    test('returns correct fraction for partial progress', () {
      expect(ProgressCalculator.progressFraction(48, 120), closeTo(0.4, 0.0001));
    });

    test('clamps to 1.0 if saved position exceeds duration', () {
      expect(ProgressCalculator.progressFraction(200, 120), 1.0);
    });

    test('returns 0 when total duration is zero to avoid divide-by-zero', () {
      expect(ProgressCalculator.progressFraction(10, 0), 0.0);
    });
  });

  group('ProgressCalculator.resumePositionSeconds', () {
    test('resumes at saved position when mid-video', () {
      expect(ProgressCalculator.resumePositionSeconds(48, 120), 48);
    });

    test('returns 0 when nothing was saved', () {
      expect(ProgressCalculator.resumePositionSeconds(0, 120), 0);
    });

    test(
      'restarts from 0 when saved position is within the completion buffer',
          () {
        // duration=30, buffer=2 -> saved=29 لازم تتحسب "خلصت"
        expect(ProgressCalculator.resumePositionSeconds(29, 30), 0);
      },
    );

    test('resumes normally when just outside the completion buffer', () {
      expect(ProgressCalculator.resumePositionSeconds(27, 30), 27);
    });
  });
}