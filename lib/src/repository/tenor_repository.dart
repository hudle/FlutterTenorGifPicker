import 'package:flutter_tenor_gif_picker/src/vo/tenor_resource.dart';
import 'package:tenor_api_service/tenor_api_service.dart';

class TenorRepository {
  final TenorApiService _apiService;

  TenorRepository(this._apiService);

  TenorCategoryResponse? _cacheCategory;

  final Map<String, TenorDataResponse> _cache = <String, TenorDataResponse>{};

  Future<TenorResource<TenorCategoryResponse>> getCategories(TenorCategoryRequest request) async{
    if (_cacheCategory != null) {
      return TenorResource(status: true, data: _cacheCategory);
    }
    try {
      _cacheCategory =  await _apiService.categories(request);
      return TenorResource(status: true, data: _cacheCategory);
    }
    catch(e) {
      return TenorResource(status: true, error: e.toString());
    }
  }

  Future<TenorResource<TenorDataResponse>> search(TenorSearchRequest request) async{

    if (request.pos == null && _cache.containsKey(request.query)) {
      return TenorResource(status: true, data: _cache[request.query]!);
    }

    try {
      final response =  await _apiService.search(request);
      if (request.pos == null) {
        _cache[request.query] = response;
      }
      return TenorResource(status: true, data: response);
    }
    catch(e) {
      return TenorResource(status: true, error: e.toString());
    }
  }
}

TenorRepository tenorRepository = TenorRepository(TenorApiProvider());

const kSomethingWentWrong = 'Something went wrong';