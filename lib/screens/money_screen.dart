import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jagan/utils/Styles.dart';
import 'package:jagan/widgets/custom_icon_button.dart';
import 'package:jagan/widgets/money_info_tile.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:jagan/providers/money_provider.dart';

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
  late Animation<double> _contentFadeAnimation;

  late MoneyProvider _moneyProvider;

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

      if (value >= 0.14 && !_moneyProvider.showConfetti) {
        _moneyProvider.setShowConfetti(true);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward().whenComplete(() async {
        _bottomController.forward();
        await Future.delayed(const Duration(milliseconds: 1100));
        _moneyProvider.setEnableSettings(true);
        await Future.delayed(const Duration(milliseconds: 200));
        _contentController.forward();
        _moneyProvider.setUpdateColor(false);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moneyProvider = Provider.of<MoneyProvider>(context, listen: false);

    _tileAnimations = List.generate(
      _moneyProvider.moneyInfoTiles.length,
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
      _moneyProvider.moneyInfoTiles.length,
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

    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Styles.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Consumer<MoneyProvider>(
        builder: (context, prov, _) {
          return Scaffold(
            backgroundColor: (prov.updateColor
                ? Styles.backgroundAlt
                : Styles.background),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                                stops: prov.updateColor
                                    ? [0.0, 0.2, 0.6]
                                    : [0.0, 0.5],
                                colors: prov.updateColor
                                    ? [
                                        Colors.transparent,
                                        Styles.gradientMid,
                                        Styles.backgroundAlt,
                                      ]
                                    : [Colors.transparent, Styles.background],
                              ),
                            ),
                          ),

                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, _) {
                              double startTop = 290;
                              double bounceTop = 360;
                              double iconWaitTop = 230;
                              double endTop = 100;

                              double dropEnd = 0.10;
                              double bounceEnd = 0.14;
                              double bounceHoldEnd = 0.40;
                              double iconMoveEnd = 0.55;
                              double blinkitStart = 0.55;
                              double blinkitEnd = 0.68;
                              double moneyStart = 0.65;
                              double moneyEnd = 0.78;
                              double holdEnd = 0.89;
                              double animationEnd = 1.0;
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

                              if (value <= dropEnd) {
                                double progress = Curves.easeOut.transform(
                                  value / dropEnd,
                                );

                                iconTop =
                                    startTop +
                                    (bounceTop - startTop) * progress;
                              } else if (value <= bounceEnd) {
                                iconTop = bounceTop;

                                double bounceProgress =
                                    (value - dropEnd) / (bounceEnd - dropEnd);

                                if (bounceProgress <= 0.5) {
                                  iconScaleY =
                                      1.0 - (squashAmount * bounceProgress * 2);
                                } else {
                                  iconScaleY =
                                      (1.0 - squashAmount) +
                                      (squashAmount *
                                          (bounceProgress - 0.5) *
                                          2);
                                }
                              } else if (value <= bounceHoldEnd) {
                                iconTop = bounceTop;
                              } else if (value <= iconMoveEnd) {
                                double progress = Curves.easeInOut.transform(
                                  (value - bounceHoldEnd) /
                                      (iconMoveEnd - bounceHoldEnd),
                                );
                                iconTop =
                                    bounceTop +
                                    (iconWaitTop - bounceTop) * progress;
                              } else if (value <= holdEnd) {
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
                                    ((value - moneyStart) /
                                            (moneyEnd - moneyStart))
                                        .clamp(0.0, 1.0);
                                moneyOpacity = Curves.easeOut.transform(
                                  moneyProgress,
                                );
                                moneyTranslateY = 20 * (1 - moneyOpacity);
                              } else {
                                double progress = Curves.easeInOut.transform(
                                  (value - holdEnd) / (animationEnd - holdEnd),
                                );
                                iconTop =
                                    iconWaitTop +
                                    (endTop - iconWaitTop) * progress;
                                logoTop =
                                    iconWaitTop +
                                    (endTop - iconWaitTop) * progress;
                                textTop =
                                    iconWaitTop +
                                    (endTop - iconWaitTop) * progress;
                                moneyFontSize = 56 - (56 * 0.1 * progress);
                                blinkitOpacity = 1;
                                moneyOpacity = 1;
                                blinkitTranslateY = 0;
                                moneyTranslateY = 0;
                              }

                              return Stack(
                                children: [
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
                                            color: Styles.lightText,
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
                                  index < prov.moneyInfoTiles.length;
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
                                          title:
                                              prov.moneyInfoTiles[index].title,
                                          description: prov
                                              .moneyInfoTiles[index]
                                              .description,
                                          imagePath: prov
                                              .moneyInfoTiles[index]
                                              .imagePath,
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
                                        backgroundColor: Styles.primaryGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Add Money",
                                        style: TextStyle(
                                          color: Styles.lightText,
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
                                      color: Styles.cardBg,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Styles.giftBg,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
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
                                              Text(
                                                "Claim Gift Card",
                                                style: TextStyle(
                                                  color: Styles.lightText,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              Text(
                                                "Enter gift card details to claim your gift card",
                                                style: TextStyle(
                                                  color: Styles.white70,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Styles.lightText,
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
                                      color: Styles.mutedText,
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

                          if (prov.showConfetti)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: IgnorePointer(
                                child: Lottie.asset(
                                  "assets/lottie/success_confetti.json",
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
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
                                if (prov.enableSettings)
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
          );
        },
      ),
    );
  }
}
