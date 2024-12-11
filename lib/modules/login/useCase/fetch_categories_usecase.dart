

import '../../login/domain/dto/category_dto.dart';
import '../../login/domain/repository/category_repository.dart';

class FetchCategoriesUseCase {
  final CategoryRepository repository;

  FetchCategoriesUseCase({required this.repository});

  Future<List<CategoryDTO>> execute() async {
    return await repository.getCategories();
  }
}
