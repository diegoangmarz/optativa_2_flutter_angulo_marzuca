
import '../../../../infrastructure/connection/api_service.dart';
import '../dto/product_detail_dto.dart';

abstract class ProductDetailRepository {
  Future<ProductDetailDTO> fetchProductDetail(int productId);
}

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ApiService apiService;

  ProductDetailRepositoryImpl({required this.apiService});

  @override
  Future<ProductDetailDTO> fetchProductDetail(int productId) async {
    final productData = await apiService.fetchProductDetail(productId);
    return ProductDetailDTO.fromJson(productData);
  }
}
