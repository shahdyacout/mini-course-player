import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';

abstract class ProgressLocalDataSource {
  Future<int> getPosition(String courseId);
  Future<Map<String, int>> getAllPositions(List<String> courseIds);
  Future<void> savePosition(String courseId, int positionSeconds);
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  static const _keyPrefix = 'progress_seconds_';
  final SharedPreferences prefs;

  ProgressLocalDataSourceImpl(this.prefs);

  @override
  Future<int> getPosition(String courseId) async {
    try {
      return prefs.getInt('$_keyPrefix$courseId') ?? 0;
    } catch (_) {
      throw const CacheException('Could not read saved progress.');
    }
  }

  @override
  Future<Map<String, int>> getAllPositions(List<String> courseIds) async {
    try {
      return {
        for (final id in courseIds) id: prefs.getInt('$_keyPrefix$id') ?? 0,
      };
    } catch (_) {
      throw const CacheException('Could not read saved progress.');
    }
  }

  @override
  Future<void> savePosition(String courseId, int positionSeconds) async {
    try {
      await prefs.setInt('$_keyPrefix$courseId', positionSeconds);
    } catch (_) {
      throw const CacheException('Could not save progress.');
    }
  }
}