import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core/utils/app_form_validattors.dart';

class SearchTextFieldWithButton extends StatelessWidget {
  const SearchTextFieldWithButton({
    super.key,
    required this.formKey,
    required this.onSubmit,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final void Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'search_field'.tr(),
                hintText: 'search_hint'.tr(),
                prefixIcon: const Icon(IconlyLight.search),
              ),
              validator: AppValidators.required.call,
              onFieldSubmitted: (v) => onSubmit(),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: ElevatedButton.icon(
            onPressed: onSubmit,
            icon: const Icon(IconlyLight.search),
            label: Text('search'.tr()),
          ),
        ),
      ],
    );
  }
}
