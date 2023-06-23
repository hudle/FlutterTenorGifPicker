import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tenor_gif_picker/src/bloc/categories/categories_cubit.dart';
import 'package:flutter_tenor_gif_picker/src/bloc/search/search_cubit.dart';
import 'package:flutter_tenor_gif_picker/src/setup/tenor_meta.dart';
import 'package:tenor_api_service/tenor_api_service.dart';

import '../vo/enum.dart';

class TenorGifPickerPage extends StatefulWidget {
  final List<String>? customCategories;
  final bool showCategory;
  final CategoryType categoryType;
  final String? preLoadText;

  const TenorGifPickerPage({
    Key? key,
    this.customCategories,
    this.showCategory = true,
    this.categoryType = CategoryType.featured,
    this.preLoadText,
  }) : super(key: key);

  @override
  State<TenorGifPickerPage> createState() => _TenorGifPickerPageState();

  static Future<TenorData?> showAsBottomSheet(
    BuildContext context, {
    List<String>? customCategories,
    bool showCategory = true,
    CategoryType categoryType = CategoryType.featured,
    String? preLoadText,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return _tenorGifPickerPageWithBloc(
            showCategory: showCategory,
            categoryType: categoryType,
            customCategories: customCategories,
            preLoadText: preLoadText,
        );
      },
      //backgroundColor: Colors.amber,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
    );
  }

  static Future<TenorData?> openAsPage(BuildContext context, {
    AppBar? appBar,
    List<String>? customCategories,
    bool showCategory = true,
    CategoryType categoryType = CategoryType.featured,
    String? preLoadText,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: appBar,
            body: _tenorGifPickerPageWithBloc(
              showCategory: showCategory,
              categoryType: categoryType,
              customCategories: customCategories,
              preLoadText: preLoadText,
            ),
          );
        },
      ),
    );
  }
}

class _TenorGifPickerPageState extends State<TenorGifPickerPage> {
  late TextEditingController _editingController;
  late ScrollController _scrollController;
  Timer? _debounce;

  late ValueNotifier<String?> _categoryNotifier;

  @override
  void initState() {
    _editingController = TextEditingController();
    _scrollController = ScrollController();

    if (widget.showCategory) {
      if (widget.customCategories != null) {
        context.read<CategoriesCubit>().emitCustom(widget.customCategories!);
      } else {
        context
            .read<CategoriesCubit>()
            .getCategories(type: widget.categoryType.name);
      }
    }
    _categoryNotifier = ValueNotifier<String?>(widget.preLoadText);
    _preLoad();


    _categoryNotifier.addListener(_onCategorySelect);
    _scrollController.addListener(_onScrollController);

    super.initState();
  }

  _preLoad() {
    if (widget.preLoadText != null) {
      context.read<SearchCubit>().search(widget.preLoadText!);
    }
  }

  _onCategorySelect() {
    if (_categoryNotifier.value != null) {
      context.read<SearchCubit>().search(_categoryNotifier.value!);
    }
  }

  _onScrollController() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      final cubit = context.read<SearchCubit>();
      if (cubit.next != null) {
        String? query = _editingController.text;
        if (query.isEmpty) {
          query = _categoryNotifier.value;
        }

        if (query?.isNotEmpty == true) {
          context.read<SearchCubit>().search(query!, next: cubit.next);
        }

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tenorMeta == null) {
      return const Center(
        child: Text("Looks like you forgot to call TenorGifPicker.init method"),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _editingController,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 400), () {
                    _categoryNotifier.value = null;
                    context.read<SearchCubit>().search(query);
                  });
                }
              },
              decoration: InputDecoration(
                  hintText: 'Search Gif',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: (){
                      _editingController.clear();
                      _preLoad();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 12)),
            ),
          ),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesResult) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      state.result.tags.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ValueListenableBuilder<String?>(
                          builder: (context, value, _) {
                            final category = state.result.tags[index].searchTerm;
                            return InkWell(
                              onTap: () {
                                _categoryNotifier.value = category;
                                _editingController.clear();
                              },
                              child: Chip(
                                label:
                                    Text(category.toUpperCase(), style: TextStyle(
                                      color: value == category ? Theme.of(context).colorScheme.onSecondary : null,
                                    ),),
                                backgroundColor: value == category ?  Theme.of(context).colorScheme.secondary : null,
                              ),
                            );
                          }, valueListenable: _categoryNotifier,
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is CategoriesError) {
                return Text(state.error);
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 10,),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchResult) {
                return Expanded(
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: state.result.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tenor = state.result[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, tenor);
                        },
                        child: Image.network(
                              tenor.mediaFormats['tinygif']!.url,
                            ),
                      );
                    },
                  ),
                );
              } else if (state is SearchError) {
                return Center(
                  child: Text(state.error),
                );
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScrollController);
    _categoryNotifier.removeListener(_onCategorySelect);
    super.dispose();
  }
}

Widget _tenorGifPickerPageWithBloc({
  List<String>? customCategories,
  bool showCategory = true,
  CategoryType categoryType = CategoryType.featured,
  String? preLoadText,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => CategoriesCubit(),
      ),
      BlocProvider(
        create: (context) => SearchCubit(),
      ),
    ],
    child: TenorGifPickerPage(
      categoryType: categoryType,
      customCategories: customCategories,
      showCategory: showCategory,
      preLoadText: preLoadText,
    ),
  );
}
