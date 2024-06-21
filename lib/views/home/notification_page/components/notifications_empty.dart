import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/responsive.dart';

class NotificationIsEmpty extends StatelessWidget {
  const NotificationIsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            height: 300,
            child: Responsive(
              mobile: SizedBox(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: SvgPicture.asset(
                    'assets/svgs/notification_empty.svg',
                    fit: BoxFit.fitWidth,
                    height: 250,
                    width: 250,
                  ),
                ),
              ),
              tablet: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: SvgPicture.asset(
                    'assets/svgs/notification_empty.svg',
                    height: 350,
                    width: 350,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'notification_empty'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'notification_empty_message'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          AppSizedBox.h16,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('go_back'.tr()),
              ),
            ),
          )
        ],
      ),
    );
  }
}
