import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../core/errors/exceptions.dart';
import '../models/course_model.dart';

abstract class CourseLocalDataSource {

  Future<List<CourseModel>> getCourses();
}

class CourseLocalDataSourceImpl implements CourseLocalDataSource {
  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final raw = await rootBundle.loadString('assets/json/courses.json');
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final list = decoded['courses'] as List<dynamic>;
      return list
          .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheException('Could not load the course catalog.');
    }
  }
}