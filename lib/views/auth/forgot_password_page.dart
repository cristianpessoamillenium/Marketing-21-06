import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/headline_with_row.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/auth/auth_controller.dart';
import '../../core/utils/app_form_validattors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/ui_util.dart';
import 'dialogs/email_sent_successfully.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ForgotPassForm(),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.adaptive.arrow_back_rounded, size: 16),
              AppSizedBox.w5,
              Text('go_back'.tr()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Forgot Password Form
class ForgotPassForm extends ConsumerStatefulWidget {
  const ForgotPassForm({super.key});

  @override
  ConsumerState<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends ConsumerState<ForgotPassForm> {
  bool _isSendingEmail = false;

  String? errorMessage;

  Future<void> _sendEmail() async {
    bool isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      AppUtil.dismissKeyboard(context: context);
      _isSendingEmail = true;
      setState(() {});

      errorMessage = await ref
          .read(authController.notifier)
          .sendResetLinkToEmail(_email.text);

      if (errorMessage == null) {
        // ignore: use_build_context_synchronously
        await UiUtil.openDialog(
            context: context, widget: const EmailSentSuccessfully());
      }

      _isSendingEmail = false;
      setState(() {});
    }
  }

  late TextEditingController _email;

  /// Formkey
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HeadlineRow(
                  headline: 'forgot_pass',
                  fontColor: AppColors.primary,
                ),
                AppSizedBox.h16,
                Text(
                  'forgot_pass_message'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                AppSizedBox.h16,
                AppSizedBox.h16,
                AutofillGroup(
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'email'.tr(),
                      prefixIcon: const Icon(IconlyLight.message),
                      errorText: errorMessage,
                      hintText: 'you@email.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.email.call,
                    onFieldSubmitted: (v) => _sendEmail(),
                    autofillHints: const [AutofillHints.email],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sendEmail,
              child: _isSendingEmail
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('send_otp'.tr()),
            ),
          ),
        ),
      ],
    );
  }
}
