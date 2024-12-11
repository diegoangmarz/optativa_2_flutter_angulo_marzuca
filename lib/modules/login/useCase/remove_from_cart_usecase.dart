
import '../../login/domain/repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> execute(int productId) async {
    try {
      await repository.removeCartItem(productId);
    } catch (e) {
      // Puedes manejar el error de forma personalizada o simplemente lanzar la excepción
      throw Exception("Error al eliminar el artículo del carrito: $e");
    }
  }
}
