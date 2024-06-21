import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/controllers/config/config_controllers.dart';

import '../../core/components/country_flag.dart';
import '../../core/components/select_theme_mode.dart';
import '../../core/constants/constants.dart';
import '../../core/localization/app_locales.dart';
import '../../core/routes/app_routes.dart';

class SelectLanguageAndThemePage extends StatelessWidget {
  const SelectLanguageAndThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectLanguage(),
              Divider(),
              AppSizedBox.h10,
              SelectThemeMode(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _DoneButton(),
    );
  }
}

class _DoneButton extends ConsumerWidget {
  const _DoneButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoginEnabled =
        ref.watch(configProvider).value?.isLoginEnabled ?? false;
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        boxShadow: AppDefaults.boxShadow,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (isLoginEnabled) {
              Navigator.pushNamed(context, AppRoutes.loginIntro);
            } else {
              Navigator.pushNamed(context, AppRoutes.entryPoint);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('done'.tr()), const Icon(IconlyLight.arrowRight2)],
          ),
        ),
      ),
    );
  }
}

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'select_language'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginIntro,
                  (v) => false,
                ),
                borderRadius: AppDefaults.borderRadius,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('skip'.tr(),
                          style: Theme.of(context).textTheme.bodySmall),
                      const Icon(IconlyLight.arrowRight2),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AppSizedBox.h16,

          /// All Languages
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppLocales.supportedLocales.length,
            itemBuilder: (context, index) {
              Locale current = AppLocales.supportedLocales[index];
              return ListTile(
                onTap: () async {
                  await context.setLocale(current);
                },
                title: Text(AppLocales.formattedLanguageName(current)),
                leading: CountryFlag(countryCode: current.countryCode ?? 'AD'),
                trailing: context.locale == current
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const SizedBox(),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
