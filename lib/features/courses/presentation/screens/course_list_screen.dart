import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/course_list/course_list_cubit.dart';
import '../cubit/course_list/course_list_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';


class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: BlocBuilder<CourseListCubit, CourseListState>(
        builder: (context, state) {
          if (state is CourseListInitial || state is CourseListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseListError) {
            return _ErrorState(
              message: state.message,
              onRetry: () => context.read<CourseListCubit>().loadCourses(),
            );
          }

          final loaded = state as CourseListLoaded;
          if (loaded.courses.isEmpty) {
            return const Center(child: Text('No courses available.'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CourseListCubit>().loadCourses(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: loaded.courses.length,
              itemBuilder: (context, index) {
                final course = loaded.courses[index];
                return CourseCard(
                  course: course,
                  progress: loaded.progressFractionFor(course),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CourseDetailScreen(course: course),
                      ),
                    );
                    if (context.mounted) {
                      context.read<CourseListCubit>().loadCourses();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}