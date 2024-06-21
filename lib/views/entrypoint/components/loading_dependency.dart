import 'package:flutter/material.dart';

import '../../../core/components/app_loader.dart';
import '../../../core/constants/constants.dart';

class LoadingDependencies extends StatelessWidget {
  const LoadingDependencies({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 7),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.asset(AppImages.appLogo),
            ),
            const Spacer(flex: 5),
            const AppLoader(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
