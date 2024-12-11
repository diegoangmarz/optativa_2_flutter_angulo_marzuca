

import '../../login/domain/dto/cart_item_dto.dart';
import '../../login/domain/repository/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository _cartRepository;

  // El constructor solo debe aceptar un parámetro, el repositorio
  GetCartItemsUseCase(this._cartRepository);

  Future<List<CartItemDTO>> execute() {
    return _cartRepository.getCartItems();
  }
}
