/// بترمى من الـ DataSources المحلية (قراءة الـ asset، أو SharedPreferences)
/// لما تحصل مشكلة في قراءة/كتابة بيانات محلية.
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'A local data error occurred.']);
}

/// بترمى لما نحتاج اتصال بالنت ومفيش.
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}

/// بترمى لما تشغيل الفيديو يفشل أو ياخد وقت أطول من المتوقع.
class PlaybackException implements Exception {
  final String message;
  const PlaybackException([this.message = 'The video could not be played.']);
}