part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
   final String error;
   SearchError(this.error);
 }
class SearchResult extends SearchState {
   final List<TenorData> result;

   SearchResult(this.result);
}
