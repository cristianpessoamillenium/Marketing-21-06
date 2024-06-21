import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class HeadlineRow extends StatelessWidget {
  const HeadlineRow({
    super.key,
    required this.headline,
    this.width,
    this.fontColor,
    this.isHeader = true,
  });

  final String headline;
  final double? width;
  final Color? fontColor;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline.tr(),
          style: isHeader
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  ),
        ),
        AppSizedBox.h5,
        Container(
          width: width ?? MediaQuery.of(context).size.width * 0.1,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppDefaults.borderRadius,
          ),
        )
      ],
    );
  }
}
