
import '../../../../infrastructure/connection/api_service.dart';
import '../../../../modules/login/domain/dto/category_dto.dart';

class CategoryRepository {
  final ApiService apiService;

  CategoryRepository({required this.apiService});

  Future<List<CategoryDTO>> getCategories() async {
    final data = await apiService.fetchCategories();
    return data.map<CategoryDTO>((json) => CategoryDTO.fromJson(json)).toList();
  }
}
