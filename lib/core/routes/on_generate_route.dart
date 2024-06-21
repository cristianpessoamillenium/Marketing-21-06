import 'package:flutter/cupertino.dart';

import '../../views/auth/forgot_password_page.dart';
import '../../views/auth/login_animation.dart';
import '../../views/auth/login_intro_page.dart';
import '../../views/auth/login_page.dart';
import '../../views/auth/signup_page.dart';
import '../../views/entrypoint/entrypoint.dart';
import '../../views/entrypoint/loading_app_page.dart';
import '../../views/explore/all_authors_page.dart';
import '../../views/explore/author_page.dart';
import '../../views/explore/category_page.dart';
import '../../views/explore/search_page.dart';
import '../../views/explore/tag_posts_page.dart';
import '../../views/home/notification_page/notification_page.dart';
import '../../views/home/post_page/comment_page.dart';
import '../../views/home/post_page/components/view_post_image_full_screen.dart';
import '../../views/home/post_page/post_page.dart';
import '../../views/onboarding/select_language_theme_page.dart';
import '../../views/settings/information_page.dart';
import '../models/article.dart';
import '../models/author.dart';
import '../models/post_tag.dart';
import 'app_routes.dart';
import 'unknown_page.dart';

class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;
    final args = settings.arguments;

    switch (route) {
      case AppRoutes.initial:
        return CupertinoPageRoute(builder: (_) => const LoadingAppPage());

      case AppRoutes.loadingApp:
        return CupertinoPageRoute(builder: (_) => const LoadingAppPage());

      case AppRoutes.selectThemeAndLang:
        return CupertinoPageRoute(
            builder: (_) => const SelectLanguageAndThemePage());

      case AppRoutes.entryPoint:
        return CupertinoPageRoute(builder: (_) => const EntryPointUI());

      case AppRoutes.login:
        return CupertinoPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.loginAnimation:
        return CupertinoPageRoute(builder: (_) => const LoggingInAnimation());

      case AppRoutes.loginIntro:
        return CupertinoPageRoute(builder: (_) => const LoginIntroPage());

      case AppRoutes.signup:
        return CupertinoPageRoute(builder: (_) => const SignUpPage());

      case AppRoutes.forgotPass:
        return CupertinoPageRoute(builder: (_) => const ForgotPasswordPage());

      case AppRoutes.search:
        return CupertinoPageRoute(builder: (_) => const SearchPage());

      case AppRoutes.notification:
        return CupertinoPageRoute(builder: (_) => const NotificationPage());

      case AppRoutes.post:
        if (args is ArticleModel) {
          return CupertinoPageRoute(builder: (_) => PostPage(article: args));
        } else {
          return errorRoute();
        }

      case AppRoutes.comment:
        if (args is ArticleModel) {
          return CupertinoPageRoute(builder: (_) => CommentPage(article: args));
        } else {
          return errorRoute();
        }

      case AppRoutes.category:
        if (args is CategoryPageArguments) {
          return CupertinoPageRoute(
              builder: (_) => CategoryPage(arguments: args));
        } else {
          return errorRoute();
        }

      case AppRoutes.tag:
        if (args is PostTag) {
          return CupertinoPageRoute(builder: (_) => TagPage(tag: args));
        } else {
          return errorRoute();
        }

      case AppRoutes.authorPage:
        if (args is AuthorData) {
          return CupertinoPageRoute(
              builder: (_) => AuthorPostPage(author: args));
        } else {
          return errorRoute();
        }

      case AppRoutes.contact:
        return CupertinoPageRoute(builder: (_) => const ContactPage());

      case AppRoutes.viewImageFullScreen:
        if (args is String) {
          return CupertinoPageRoute(
              builder: (_) => ViewImageFullScreen(url: args));
        } else {
          return errorRoute();
        }

      case AppRoutes.allAuthors:
        return CupertinoPageRoute(builder: (_) => const AllAuthorsPage());

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
