import 'package:flutter/foundation.dart';
import 'package:jagan/models/money_info_tile_model.dart';

class MoneyProvider extends ChangeNotifier {
  bool enableSettings = false;
  bool updateColor = true;
  bool showConfetti = false;

  final List<MoneyInfoTileModel> moneyInfoTiles = [
    MoneyInfoTileModel(
      title: "Single tap payments",
      description: "Enjoy seamless payments without the wait for OTPs",
      imagePath: "assets/images/single_tap_icon.png",
    ),
    MoneyInfoTileModel(
      title: "Zero failures",
      description: "Zero payment failures ensure you never misss an order",
      imagePath: "assets/images/zero_failures.png",
    ),
    MoneyInfoTileModel(
      title: "Real-time refunds",
      description:
          "No need to wait for refuds. Blinkit Money refunds are instant!",
      imagePath: "assets/images/real_time.png",
    ),
  ];

  void setEnableSettings(bool v) {
    if (enableSettings != v) {
      enableSettings = v;
      notifyListeners();
    }
  }

  void setUpdateColor(bool v) {
    if (updateColor != v) {
      updateColor = v;
      notifyListeners();
    }
  }

  void setShowConfetti(bool v) {
    if (showConfetti != v) {
      showConfetti = v;
      notifyListeners();
    }
  }

  void clear() {
    enableSettings = false;
    updateColor = true;
    showConfetti = false;
    notifyListeners();
  }
}
