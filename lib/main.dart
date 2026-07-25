import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/courses/presentation/cubit/course_list/course_list_cubit.dart';
import 'features/courses/presentation/screens/course_list_screen.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final di = InjectionContainer();
  await di.init();

  runApp(CoursePlayerApp(di: di));
}

class CoursePlayerApp extends StatelessWidget {
  final InjectionContainer di;

  const CoursePlayerApp({super.key, required this.di});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<InjectionContainer>.value(
      value: di,
      child: BlocProvider(
        create: (_) => CourseListCubit(
          getCourses: di.getCourses,
          getAllProgress: di.getAllProgress,
        )..loadCourses(),
        child: MaterialApp(
          title: 'Mini Course Player',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
          home: const CourseListScreen(),
        ),
      ),
    );
  }
}