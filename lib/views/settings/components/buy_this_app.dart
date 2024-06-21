import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/app_utils.dart';
import 'setting_list_tile.dart';

class BuyAppSettings extends StatelessWidget {
  const BuyAppSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(AppDefaults.margin),
        ),
        SettingTile(
          label: 'buy_this_app',
          icon: IconlyLight.buy,
          iconColor: Colors.teal,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            const url =
                'https://onabet.cxclick.com/visit/?bta=41906&brand=onabet&utm_campaign=Menu';
            AppUtil.launchUrl(url);
          },
        ),
      ],
    );
  }
}
