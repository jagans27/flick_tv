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
  late AnimationController _bottomController;
  late AnimationController _contentController;
  late List<Animation<double>> _tileScaleAnimations;
  late List<Animation<Offset>> _tileAnimations;
  late Animation<Offset> _buttonAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _contentFadeAnimation;
  bool enableSettings = false;
  bool updateColor = true;

  bool _showConfetti = false;

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
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    _bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animationController.addListener(() {
      double value = _animationController.value;

      // Play confetti after bounce ends
      if (value >= 0.14 && !_showConfetti) {
        _showConfetti = true;
      }
      setState(() {});
    });

    // Create staggered animations for each tile
    _tileAnimations = List.generate(
      moneyInfoTiles.length,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _bottomController,
              curve: Interval(
                index * 0.3,
                (index * 0.3) + 0.15,
                curve: Curves.easeOut,
              ),
            ),
          ),
    );

    _tileScaleAnimations = List.generate(
      moneyInfoTiles.length,
      (index) => Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(
          parent: _bottomController,
          curve: Interval(
            index * 0.3,
            (index * 0.3) + 0.15,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    // Button and content animations (after tiles finish)
    _buttonAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _bottomController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );

    _buttonFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _bottomController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    // Header animations (money icon, logo, text)
    // Logo slides up: 0.25 - 0.67s
    _logoSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.25, 0.67, curve: Curves.easeOut),
          ),
        );

    // Text slides up: 0.35 - 0.67s (slightly staggered)
    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.35, 0.67, curve: Curves.easeOut),
          ),
        );

    // Fade in during icon jump phase
    _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _animationController.forward().whenComplete(() async {
      _bottomController.forward();
      await Future.delayed(const Duration(milliseconds: 1100));
      setState(() {
        enableSettings = true;
      });
      await Future.delayed(const Duration(milliseconds: 200));
      _contentController.forward();
      setState(() {
        updateColor = false;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bottomController.dispose();
    _contentController.dispose();
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
        backgroundColor: Color(updateColor ? 0xff1d1c21 : 0xff161519),

        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: updateColor ? [0.0, 0.2, 0.6] : [0.0, 0.5],
                            // colors: ,
                            colors: updateColor
                                ? [
                                    Colors.transparent,
                                    Color(0xff2c291f),
                                    Color(0xff1d1c21),
                                  ]
                                : [Colors.transparent, Color(0xff161519)],
                          ),
                        ),
                      ),

                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, _) {
                          /// POSITIONS
                          double startTop = 290;
                          double bounceTop = 360;
                          double iconWaitTop = 230;
                          double endTop = 100;

                          /// TIMINGS
                          double dropEnd = 0.10;
                          double bounceEnd = 0.14;

                          // HOLD at 350 after bounce
                          double bounceHoldEnd = 0.40;

                          double iconMoveEnd = 0.55;

                          // Blinkit logo timing
                          double blinkitStart = 0.55;
                          double blinkitEnd = 0.68;

                          // MONEY timing
                          double moneyStart = 0.65;
                          double moneyEnd = 0.78;

                          double holdEnd = 0.89;
                          double animationEnd = 1.0;

                          /// BOUNCE
                          double squashAmount = 0.2;

                          double iconTop = startTop;
                          double logoTop = iconWaitTop;
                          double textTop = iconWaitTop;

                          double iconScaleY = 1.0;

                          double blinkitOpacity = 0;
                          double moneyOpacity = 0;

                          double blinkitTranslateY = 20;
                          double moneyTranslateY = 20;

                          double moneyFontSize = 56;

                          double value = _animationController.value;

                          // PHASE 1: Drop 260 -> 350
                          if (value <= dropEnd) {
                            double progress = Curves.easeOut.transform(
                              value / dropEnd,
                            );

                            iconTop =
                                startTop + (bounceTop - startTop) * progress;
                          }
                          // PHASE 2: Bounce squash
                          else if (value <= bounceEnd) {
                            iconTop = bounceTop;

                            double bounceProgress =
                                (value - dropEnd) / (bounceEnd - dropEnd);

                            if (bounceProgress <= 0.5) {
                              iconScaleY =
                                  1.0 - (squashAmount * bounceProgress * 2);
                            } else {
                              iconScaleY =
                                  (1.0 - squashAmount) +
                                  (squashAmount * (bounceProgress - 0.5) * 2);
                            }
                          } else if (value <= bounceHoldEnd) {
                            iconTop = bounceTop; // stay at 350
                          }
                          // PHASE 3: Only icon moves 350 -> 230
                          else if (value <= iconMoveEnd) {
                            double progress = Curves.easeInOut.transform(
                              (value - bounceHoldEnd) /
                                  (iconMoveEnd - bounceHoldEnd),
                            );

                            iconTop =
                                bounceTop +
                                (iconWaitTop - bounceTop) * progress;
                          }
                          // PHASE 4: Stagger reveal
                          else if (value <= holdEnd) {
                            iconTop = iconWaitTop;
                            logoTop = iconWaitTop;
                            textTop = iconWaitTop;

                            double blinkitProgress =
                                ((value - blinkitStart) /
                                        (blinkitEnd - blinkitStart))
                                    .clamp(0.0, 1.0);
                            blinkitOpacity = Curves.easeOut.transform(
                              blinkitProgress,
                            );
                            blinkitTranslateY = 20 * (1 - blinkitOpacity);

                            double moneyProgress =
                                ((value - moneyStart) / (moneyEnd - moneyStart))
                                    .clamp(0.0, 1.0);
                            moneyOpacity = Curves.easeOut.transform(
                              moneyProgress,
                            );
                            moneyTranslateY = 20 * (1 - moneyOpacity);
                          }
                          // PHASE 5 stays the same...
                          // PHASE 5: Move everything to top
                          else {
                            double progress = Curves.easeInOut.transform(
                              (value - holdEnd) / (animationEnd - holdEnd),
                            );

                            iconTop =
                                iconWaitTop + (endTop - iconWaitTop) * progress;

                            logoTop =
                                iconWaitTop + (endTop - iconWaitTop) * progress;

                            textTop =
                                iconWaitTop + (endTop - iconWaitTop) * progress;

                            moneyFontSize = 56 - (56 * 0.1 * progress);

                            blinkitOpacity = 1;
                            moneyOpacity = 1;
                            blinkitTranslateY = 0;
                            moneyTranslateY = 0;
                          }

                          return Stack(
                            children: [
                              /// MONEY ICON
                              Positioned(
                                top: iconTop,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..scale(1.0, iconScaleY, 1.0),
                                    child: Image.asset(
                                      "assets/images/money_icon.png",
                                      width: 120,
                                    ),
                                  ),
                                ),
                              ),

                              /// BLINKIT LOGO (slides first)
                              Positioned(
                                top: logoTop + 120,
                                left: 0,
                                right: 0,
                                child: Opacity(
                                  opacity: blinkitOpacity,
                                  child: Transform.translate(
                                    offset: Offset(0, blinkitTranslateY),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/images/blinkit_logo.png",
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// MONEY TEXT (slides second)
                              Positioned(
                                top: textTop + 150,
                                left: 0,
                                right: 0,
                                child: Opacity(
                                  opacity: moneyOpacity,
                                  child: Transform.translate(
                                    offset: Offset(0, moneyTranslateY),
                                    child: Text(
                                      "MONEY",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: moneyFontSize,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 320,
                          left: 16,
                          right: 16,
                          bottom: 30,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),

                            for (
                              int index = 0;
                              index < moneyInfoTiles.length;
                              index++
                            ) ...[
                              SlideTransition(
                                position: _tileAnimations[index],
                                child: ScaleTransition(
                                  scale: _tileScaleAnimations[index],
                                  alignment: Alignment.bottomCenter,
                                  child: FadeTransition(
                                    opacity: Tween<double>(begin: 0, end: 1)
                                        .animate(
                                          CurvedAnimation(
                                            parent: _bottomController,
                                            curve: Interval(
                                              index * 0.3,
                                              (index * 0.3) + 0.15,
                                              curve: Curves.easeOut,
                                            ),
                                          ),
                                        ),
                                    child: MoneyInfoTile(
                                      title: moneyInfoTiles[index].title,
                                      description:
                                          moneyInfoTiles[index].description,
                                      imagePath:
                                          moneyInfoTiles[index].imagePath,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            FadeTransition(
                              opacity: _contentFadeAnimation,
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

                            const SizedBox(height: 30),
                            FadeTransition(
                              opacity: _contentFadeAnimation,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                            const SizedBox(height: 40),
                            FadeTransition(
                              opacity: _contentFadeAnimation,
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
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),

                      if (_showConfetti)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Lottie.asset(
                              "assets/lottie/success_confetti.json",
                              height: MediaQuery.of(context).size.height * 0.4,
                              fit: BoxFit.fill,
                              repeat: false, // play only once
                            ),
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
                            if (enableSettings)
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
          },
        ),
      ),
    );
  }
}
