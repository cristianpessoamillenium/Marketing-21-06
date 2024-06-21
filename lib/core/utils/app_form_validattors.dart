import 'package:easy_localization/easy_localization.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AppValidators {
  static MultiValidator email = MultiValidator([
    EmailValidator(errorText: 'enter_a_valid_email'.tr()),
    RequiredValidator(errorText: 'this_field_is_required'.tr()),
  ]);

  static MultiValidator password = MultiValidator([
    RequiredValidator(errorText: 'password_required'.tr()),
  ]);

  static RequiredValidator required =
      RequiredValidator(errorText: 'this_field_is_required'.tr());

  static RequiredValidator requiredWithName(String name) =>
      RequiredValidator(errorText: '$name ${'is_required'.tr()}');

  static String? passwordMatcher(String password1, String password2) =>
      MatchValidator(errorText: 'passwords_do_not_match'.tr())
          .validateMatch(password1, password2);
}
