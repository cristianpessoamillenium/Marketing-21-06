import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../repositories/posts/post_repository.dart';
import '../../routes/app_routes.dart';

final applinkNotifierProvider =
    StateNotifierProvider.family<AppLinksNotifier, String?, BuildContext>(
        (ref, context) {
  return AppLinksNotifier(ref, context);
});

class AppLinksNotifier extends StateNotifier<String?> {
  AppLinksNotifier(this.ref, this.context) : super(null) {
    {
      _applyListener();
    }
  }

  final StateNotifierProviderRef ref;
  final BuildContext context;

  _applyListener() async {
    final appLinks = AppLinks();
    final initialLink = await appLinks.getInitialLinkString();
    await handleLinks(initialLink);

    // Parse the link and warn the user, if it is not correct,
    // but keep in mind it could be `null`.

    var subscription = appLinks.stringLinkStream.listen((String? link) {
      // Use the uri and warn the user, if it is not correct
      handleLinks(link);
    }, onError: (err) {
      debugPrint(err);
    });

    ref.onDispose(() {
      subscription.cancel();
    });
  }

  handleLinks(String? initialLink) async {
    if (initialLink != null) {
      Fluttertoast.showToast(msg: 'loading'.tr());
      context.loaderOverlay.show();
      debugPrint('Initial Link is $initialLink');
      final repo = ref.read(postRepoProvider);
      final post = await repo.getPostFromUrl(
        requestedURL: initialLink,
      );
      debugPrint(post.toString());
      if (post != null) {
        Navigator.pushNamed(context, AppRoutes.post, arguments: post);
      } else {}
      context.loaderOverlay.hide();
    }
  }
}
