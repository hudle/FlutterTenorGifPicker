import 'package:bloc/bloc.dart';
import 'package:flutter_tenor_gif_picker/src/repository/tenor_repository.dart';
import 'package:flutter_tenor_gif_picker/src/setup/tenor_meta.dart';
import 'package:meta/meta.dart';
import 'package:tenor_api_service/tenor_api_service.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  void getCategories({required String type}) async {
    emit(CategoriesLoading());

    final result = await tenorRepository.getCategories(
      TenorCategoryRequest(
          key: tenorMeta!.apiKey,
          country: tenorMeta?.country,
          clientKey: tenorMeta?.clientKey,
          locale: tenorMeta?.locale,
          type: type),
    );

    if (result.status) {
      emit(CategoriesResult(result.data!));
    } else {
      emit(CategoriesError(result.error));
    }
  }

  void emitCustom(List<String> categories) {
    emit(
      CategoriesResult(
        TenorCategoryResponse(
          locale: '',
          tags: categories
              .map((e) =>
                  TenorCategory(name: e, image: '', path: '', searchTerm: e))
              .toList(),
        ),
      ),
    );
  }
}
