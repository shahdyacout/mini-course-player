import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';


/// شكل موحّد لأي "عملية عمل واحدة" (Use Case). [Type] هو نوع النتيجة
/// لو نجحت، و[Params] هو المدخلات اللي العملية محتاجاها.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// نوع علامة (marker) للـ UseCases اللي مش محتاجة أي مدخلات.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}