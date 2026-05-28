import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jagan/models/money_info_tile_model.dart';
import 'package:jagan/widgets/custom_icon_button.dart';
import 'package:jagan/widgets/money_info_tile.dart';
import 'package:lottie/lottie.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => MoneyScreenState();
}

class MoneyScreenState extends State<MoneyScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _tileAnimations;
  late Animation<Offset> _buttonAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<Offset> _iconAnimation;
  late Animation<Offset> _logoAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _headerFadeAnimation;

  List<MoneyInfoTileModel> moneyInfoTiles = [
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Create staggered animations for each tile
    _tileAnimations = List.generate(
      moneyInfoTiles.length,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.15,
                0.4 + index * 0.15,
                curve: Curves.easeOut,
              ),
            ),
          ),
    );

    // Button and content animations (after tiles finish)
    _buttonAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
          ),
        );

    _buttonFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    // Header animations (money icon, logo, text)
    _iconAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _logoAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xff161519),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xff161519),

        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Background Image
              Image.asset(
                "assets/images/header_image.png",
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
              ),

              // Gradient Overlay
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.9],
                    colors: [Colors.transparent, Color(0xff161519)],
                  ),
                ),
              ),
              // Scrollable Content
              Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 16,
                  right: 16,
                  bottom: 30,
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/images/money_icon.png", width: 120),

                        const SizedBox(height: 16),

                        Image.asset(
                          "assets/images/blinkit_logo.png",
                          width: 80,
                        ),

                        const Text(
                          "MONEY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    for (
                      int index = 0;
                      index < moneyInfoTiles.length;
                      index++
                    ) ...[
                      SlideTransition(
                        position: _tileAnimations[index],
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                index * 0.15,
                                0.4 + index * 0.15,
                                curve: Curves.easeOut,
                              ),
                            ),
                          ),
                          child: MoneyInfoTile(
                            title: moneyInfoTiles[index].title,
                            description: moneyInfoTiles[index].description,
                            imagePath: moneyInfoTiles[index].imagePath,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    SlideTransition(
                      position: _buttonAnimation,
                      child: FadeTransition(
                        opacity: _buttonFadeAnimation,
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xff328616),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Add Money",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _buttonAnimation,
                      child: FadeTransition(
                        opacity: _buttonFadeAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff202126),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xff67430f),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/gift_icon.png",
                                    width: 60,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Claim Gift Card",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Text(
                                      "Enter gift card details to claim your gift card",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SlideTransition(
                      position: _buttonAnimation,
                      child: FadeTransition(
                        opacity: _buttonFadeAnimation,
                        child: Text(
                          "Enjoy seamless\none tap payments",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff424348),
                            fontSize: 40,
                            height: 0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Lottie.asset(
                  "assets/lottie/success_confetti.json",
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.fill,
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).padding.top + 5,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icons.arrow_back_ios_sharp,
                    ),
                    CustomIconButton(
                      onPressed: () {},
                      icon: Icons.settings_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
