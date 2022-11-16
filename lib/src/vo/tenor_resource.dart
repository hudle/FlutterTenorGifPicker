import '../repository/tenor_repository.dart';

class TenorResource<T> {
  final bool status;
  final T? data;
  final String error;

  TenorResource({required this.status, this.data, this.error = kSomethingWentWrong});
}