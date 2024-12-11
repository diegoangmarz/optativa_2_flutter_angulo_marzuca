

import '../../login/domain/dto/product_detail_dto.dart';
import '../../login/domain/repository/product_detail_repository.dart';

class FetchProductDetailUseCase {
  final ProductDetailRepository repository;

  FetchProductDetailUseCase({required this.repository});

  Future<ProductDetailDTO> execute(productId) {
    return repository.fetchProductDetail(productId);
  }
}
