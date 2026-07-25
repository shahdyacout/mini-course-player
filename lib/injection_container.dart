import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'features/courses/data/datasource/course_local_datasource.dart';
import 'features/courses/data/datasource/progress_local_datasource.dart';
import 'features/courses/data/repositories/course_repository_impl.dart';
import 'features/courses/domain/repositories/course_repository.dart';
import 'features/courses/domain/usecases/get_all_progress.dart';
import 'features/courses/domain/usecases/get_courses.dart';
import 'features/courses/domain/usecases/get_progress.dart';
import 'features/courses/domain/usecases/save_progress.dart';

/// حاوية بسيطة يدوية للاعتماديات (Dependency Injection). مشروع بالحجم
/// ده مش محتاج مكتبة service-locator (زي get_it) — مكان واحد بيبني
/// شجرة الاعتماديات كله كفاية، وبيسهّل قراءة "مين بيعتمد على مين" دفعة واحدة.
class InjectionContainer {
  late final NetworkInfo networkInfo;
  late final CourseRepository courseRepository;

  late final GetCourses getCourses;
  late final GetAllProgress getAllProgress;
  late final GetProgress getProgress;
  late final SaveProgress saveProgress;

  /// لازم تتنادى مرة واحدة (await) قبل الاستخدام، لأن SharedPreferences
  /// محتاجة تهيئة async.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    networkInfo = NetworkInfoImpl(Connectivity());

    courseRepository = CourseRepositoryImpl(
      localDataSource: CourseLocalDataSourceImpl(),
      progressDataSource: ProgressLocalDataSourceImpl(prefs),
      networkInfo: networkInfo,
    );

    getCourses = GetCourses(courseRepository);
    getAllProgress = GetAllProgress(courseRepository);
    getProgress = GetProgress(courseRepository);
    saveProgress = SaveProgress(courseRepository);
  }
}