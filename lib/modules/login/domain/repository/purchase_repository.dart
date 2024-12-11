import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


import '../dto/purchase_dto.dart';

class PurchaseRepository {
  final String _purchasesKey = 'purchases';

  Future<List<PurchaseDTO>> getPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    final purchasesData = prefs.getString(_purchasesKey) ?? '[]';
    final List<dynamic> purchases = jsonDecode(purchasesData);

    return purchases
        .map((purchase) => PurchaseDTO.fromMap(purchase as Map<String, dynamic>))
        .toList();
  }

  Future<void> savePurchase(PurchaseDTO purchase, double total) async {
    final prefs = await SharedPreferences.getInstance();
    final purchasesData = prefs.getString(_purchasesKey) ?? '[]';
    final List<dynamic> purchases = jsonDecode(purchasesData);

    purchases.add(purchase.toMap());

    await prefs.setString(_purchasesKey, jsonEncode(purchases));
  }
}
