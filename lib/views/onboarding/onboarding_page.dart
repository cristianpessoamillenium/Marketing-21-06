import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Adicionar esta linha
import '../../core/controllers/config/config_controllers.dart';

import '../../../core/constants/constants.dart';
import '../../config/wp_config.dart';
import '../../core/components/forward_icon_button.dart';
import '../../core/repositories/others/onboarding_local.dart';
import '../../core/routes/app_routes.dart';
import 'components/onboarding_active_row.dart';
import 'components/onboarding_content.dart';
import 'components/onboarding_header.dart';
import 'data/onboarding_data.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController controller;
  int currentIndex = 0;
  final _repo = OnboardingRepository();

  /// When users swipes
  void _onPageChanged(int? index) {
    if (index != null) {
      currentIndex = index;
      setState(() {});
    }
  }

  /// When users press forward button
  void _onForward() {
    int totalPage = OnboardingData.allBoards.length;
    if (currentIndex + 1 != totalPage) {
      controller.animateToPage(
        currentIndex + 1,
        duration: AppDefaults.duration,
        curve: Curves.ease,
      );
    } else {
      // Navigate to login page
      _navigateToSelectionPage();
    }
  }

  /// When users presses skips
  Future<void> _navigateToSelectionPage() async {
    _repo.saveIntroDone();

    // Salvar que o onboarding foi completado
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);

    final multi = ref.read(configProvider).value?.multiLanguageEnabled ?? false;
    final isLoginEnabled =
        ref.watch(configProvider).value?.isLoginEnabled ?? false;
    if (multi) {
      Navigator.pushNamed(context, AppRoutes.selectThemeAndLang);
    } else {
      if (isLoginEnabled) {
        Navigator.pushNamed(context, AppRoutes.loginIntro);
      } else {
        Navigator.pushNamed(context, AppRoutes.entryPoint);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(
                title: WPConfig.appName, onSkip: _navigateToSelectionPage),
            const Spacer(),
            // Image and text
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView(
                controller: controller,
                onPageChanged: _onPageChanged,
                children: List.generate(
                  OnboardingData.allBoards.length,
                      (index) => OnboardingContent(
                    data: OnboardingData.allBoards[index],
                  ),
                ),
              ),
            ),
            const Spacer(),
            OnboardingActiveRow(
              totalLength: OnboardingData.allBoards.length,
              currentIndex: currentIndex,
            ),
            const Spacer(),

            ForwardIconButton(onTap: _onForward)
          ],
        ),
      ),
    );
  }
}
