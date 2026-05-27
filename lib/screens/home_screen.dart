import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/animation_provider.dart';
import 'money_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnimationProvider>();

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xff0B0B12),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2BAA42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoneyScreen()),
                    );
                  },
                  child: Text(
                    provider.buttonLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
