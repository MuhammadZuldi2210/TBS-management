// import flutter
import 'package:flutter/material.dart';

// import service
import '../services/coin_service.dart';

class CoinProvider extends ChangeNotifier {
  final CoinService _service = CoinService();

  bool isLoading = false;

  String? errorMessage;

  // ===============================
  // REQUEST COIN
  // ADMIN / RESELLER
  // ===============================
  Future<bool> requestCoin({
    required int amount,
    required String requestTo,
    String? notes,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      await _service.requestCoin(
        amount: amount,
        requestTo: requestTo,
        notes: notes,
      );

      isLoading = false;

      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;

      errorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  // ===============================
  // GET MY RESELLER
  // ===============================
  Future getMyReseller() async {
    try {
      final data = await _service.getMyReseller();

      return data;
    } catch (e) {
      errorMessage = e.toString();

      notifyListeners();

      return [];
    }
  }
}
