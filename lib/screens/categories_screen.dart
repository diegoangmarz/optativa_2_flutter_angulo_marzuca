import '../infrastructure/connection/api_service.dart';
import '../modules/login/useCase/fetch_categories_usecase.dart';
import '../modules/login/domain/repository/category_repository.dart';
import '../modules/login/domain/dto/category_dto.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late FetchCategoriesUseCase fetchCategoriesUseCase;
  List<CategoryDTO> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    final apiService = ApiService();
    final categoryRepository = CategoryRepository(apiService: apiService);
    fetchCategoriesUseCase = FetchCategoriesUseCase(repository: categoryRepository);

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await fetchCategoriesUseCase.execute();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  subtitle: Text(category.slug),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/products',
                      arguments: category.slug, // Pasar solo el slug como String
                    );
                  },
                );
              },
            ),
    );
  }
}
