import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Unified loading / success / error state for UI and controllers.
sealed class Resource<T> extends Equatable {
  const Resource();

  @override
  List<Object?> get props => [];
}

class ResourceInitial<T> extends Resource<T> {
  const ResourceInitial();
}

class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading();
}

class ResourceSuccess<T> extends Resource<T> {
  const ResourceSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

class ResourceError<T> extends Resource<T> {
  const ResourceError(this.failure);

  final Failure failure;

  String get message => failure.message;

  @override
  List<Object?> get props => [failure];
}

extension ResourceX<T> on Resource<T> {
  bool get isInitial => this is ResourceInitial<T>;
  bool get isLoading => this is ResourceLoading<T>;
  bool get isSuccess => this is ResourceSuccess<T>;
  bool get isError => this is ResourceError<T>;

  T? get dataOrNull =>
      this is ResourceSuccess<T> ? (this as ResourceSuccess<T>).data : null;

  Failure? get failureOrNull =>
      this is ResourceError<T> ? (this as ResourceError<T>).failure : null;
}
