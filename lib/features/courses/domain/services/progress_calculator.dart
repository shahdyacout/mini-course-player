
class ProgressCalculator {

  static const int completionBufferSeconds = 2;

  static double progressFraction(int positionSeconds, int totalSeconds) {
    if (totalSeconds <= 0) return 0.0;
    final fraction = positionSeconds / totalSeconds;
    if (fraction.isNaN) return 0.0;
    return fraction.clamp(0.0, 1.0);
  }

  static int resumePositionSeconds(int savedPositionSeconds, int totalSeconds) {
    if (savedPositionSeconds <= 0) return 0;
    if (totalSeconds > 0 &&
        savedPositionSeconds >= totalSeconds - completionBufferSeconds) {
      return 0;
    }
    return savedPositionSeconds;
  }
}