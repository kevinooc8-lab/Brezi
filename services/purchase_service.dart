import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Pembungkus RevenueCat. Tanpa kunci API, aplikasi berjalan dalam mode demo.
/// Jalankan dengan: --dart-define=RC_API_KEY=kunci_publik_revenuecat
class PurchaseService {
  static const _key = String.fromEnvironment('RC_API_KEY');
  static const entitlement = 'pro';

  static bool get live => _key.isNotEmpty && !kIsWeb;

  static Future<void> init() async {
    if (!live) return;
    try {
      await Purchases.configure(PurchasesConfiguration(_key));
    } catch (_) {}
  }

  static Future<bool> checkPro() async {
    if (!live) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(entitlement);
    } catch (_) {
      return false;
    }
  }

  static Future<List<Package>> packages() async {
    try {
      final o = await Purchases.getOfferings();
      return o.current?.availablePackages ?? [];
    } catch (_) {
      return [];
    }
  }

  static Future<bool> buy(Package p) async {
    try {
      final info = await Purchases.purchasePackage(p);
      return info.entitlements.active.containsKey(entitlement);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey(entitlement);
    } catch (_) {
      return false;
    }
  }
}
