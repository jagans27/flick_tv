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

  // This method will be called to toggle the settings button in the UI
  void setEnableSettings(bool value) {
    if (enableSettings != value) {
      enableSettings = value;
      notifyListeners();
    }
  }

  // This method will be called to toggle the color update in the UI
  void setUpdateColor(bool value) {
    if (updateColor != value) {
      updateColor = value;
      notifyListeners();
    }
  }

  // This method will be called to show or hide confetti in the UI
  void setShowConfetti(bool value) {
    if (showConfetti != value) {
      showConfetti = value;
      notifyListeners();
    }
  }

  // Call this method to reset all values to their initial state
  void clear() {
    enableSettings = false;
    updateColor = true;
    showConfetti = false;
    notifyListeners();
  }
}
