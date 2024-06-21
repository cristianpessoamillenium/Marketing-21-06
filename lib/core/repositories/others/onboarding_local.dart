import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final onboardingProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository();
});

class OnboardingRepository {
  final _boxKey = 'intro';
  final _dataKey = 'isIntroDone';
  final _consent = 'isConsentDone';

  Future<OnboardingRepository> init() async {
    await Hive.openBox(_boxKey);
    return this;
  }

  bool isIntroDone() {
    var box = Hive.box(_boxKey);
    return box.get(_dataKey) ?? false;
  }

  void saveIntroDone() async {
    var box = Hive.box(_boxKey);
    await box.put(_dataKey, true);
  }

  bool isConsentDone() {
    var box = Hive.box(_boxKey);
    return box.get(_consent) ?? false;
  }

  void saveConsentDone() {
    var box = Hive.box(_boxKey);
    box.put(_consent, true);
  }
}
