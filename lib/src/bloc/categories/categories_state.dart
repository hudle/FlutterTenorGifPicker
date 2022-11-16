part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesError extends CategoriesState {
   final String error;
   CategoriesError(this.error);
 }
class CategoriesResult extends CategoriesState {
   final TenorCategoryResponse result;

   CategoriesResult(this.result);
}
