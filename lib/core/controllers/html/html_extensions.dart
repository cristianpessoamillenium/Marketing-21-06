import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../config/app_images_config.dart';
import '../../../views/home/post_page/components/post_gallery_handler.dart';
import '../../components/app_loader.dart';
import '../../components/app_video.dart';
import '../../components/network_image.dart';
import '../../components/skeleton.dart';
import '../../themes/theme_manager.dart';
import '../../utils/app_utils.dart';

class AppHtmlVideoExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'video'};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(child: returnView(context));
  }

  Widget returnView(ExtensionContext context) {
    try {
      final src = context.element!.attributes['src']!.toString();
      final width = context.element?.attributes['width'] ?? '1920';
      final height = context.element!.attributes['height'] ?? '1080';

      double? aspectRatio;
      aspectRatio = double.parse(width) / double.parse(height);

      if (src.contains('youtube')) {
        return AppVideo(url: src, type: 'youtube', aspectRatio: aspectRatio);
      } else if (src.contains('vimeo')) {
        return AppVideo(url: src, type: 'vimeo', aspectRatio: aspectRatio);
      } else {
        return AppVideo(
          url: src,
          type: 'network',
          aspectRatio: aspectRatio,
        );
      }
    } catch (e) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: NetworkImageWithLoader(AppImagesConfig.noImageUrl),
      );
    }
  }
}

class AppHtmlIframeExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'iframe'};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(child: returnView(context));
  }

  Widget returnView(ExtensionContext context) {
    final String videoSource = context.element!.attributes['src'].toString();
    final width = context.element?.attributes['width'] ?? '1920';
    final height = context.element!.attributes['height'] ?? '1080';

    double? aspectRatio;
    aspectRatio = double.parse(width) / double.parse(height);
    if (videoSource.contains('youtube')) {
      return AppVideo(
        url: videoSource,
        type: 'youtube',
        aspectRatio: aspectRatio,
      );
    } else if (videoSource.contains('vimeo')) {
      return AppVideo(
        url: videoSource,
        type: 'vimeo',
        aspectRatio: aspectRatio,
      );
    } else if (videoSource.contains('facebook.com')) {
      return SocialEmbedRenderer(data: videoSource, platform: 'facebook');
    } else {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: NetworkImageWithLoader(AppImagesConfig.noImageUrl),
      );
    }
  }
}

class AppHtmlImageExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'img'};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(child: returnView(context));
  }

  Widget returnView(ExtensionContext context) {
    final src = context.element?.attributes['src'].toString();
    final link =
        context.element?.attributes['href'].toString(); // Fetch hyperlink

    // Wrap CachedNetworkImage with GestureDetector if a hyperlink is present
    return link != null
        ? GestureDetector(
            onTap: () {
              // Handle onTap event
              // You can navigate to the link or perform any other action
            },
            child: CachedNetworkImage(
              imageUrl: src ?? AppImagesConfig.noImageUrl,
              placeholder: (context, url) => const AspectRatio(
                aspectRatio: 16 / 9,
                child: Skeleton(),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: src ?? AppImagesConfig.noImageUrl,
            placeholder: (context, url) => const AspectRatio(
              aspectRatio: 16 / 9,
              child: Skeleton(),
            ),
          );
  }
}

class AppHtmlGalleryRender extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'wp-block-gallery'};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(child: returnView(context));
  }

  @override
  bool matches(ExtensionContext context) {
    return context.element?.classes.contains('wp-block-gallery') ?? false;
  }

  Widget returnView(ExtensionContext context) {
    List<String> imagesUrl = [];
    final src = context.element?.children ?? [];
    imagesUrl =
        src.map((e) => e.children.first.attributes['src'] ?? '').toList();

    return PostGalleryRenderer(imagesUrl: imagesUrl);
  }
}

class AppHtmlBlockquoteExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'blockquote'};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(child: returnView(context));
  }

  Widget returnView(ExtensionContext context) {
    if (context.classes.contains('twitter-tweet')) {
      return SocialEmbedRenderer(data: context.innerHtml, platform: 'twitter');
    } else if (context.classes.contains('instagram-media')) {
      return SocialEmbedRenderer(
          data: context.element!.outerHtml, platform: 'instagram');
    } else if (context.classes.contains('wp-block-quote')) {
      return QuoteRenderer(quote: context.innerHtml);
    } else {
      return SocialEmbedRenderer(data: context.innerHtml, platform: null);
    }
  }
}

class AppHtmlCodeExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'code'};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(child: returnView(context));
  }

  Widget returnView(ExtensionContext context) {
    final code =
        HtmlUnescape().convert(parse(context.innerHtml).documentElement!.text);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SyntaxView(
        code: code,
        syntax: Syntax.DART,
        syntaxTheme: SyntaxTheme.vscodeDark(),
        fontSize: 12.0,
        withZoom: true,
        expanded: false,
        selectable: true,
      ),
    );
  }
}

class SocialEmbedRenderer extends ConsumerStatefulWidget {
  const SocialEmbedRenderer({super.key, required this.data, this.platform});

  final String data;
  final String? platform;

  @override
  ConsumerState<SocialEmbedRenderer> createState() => _SocialEmbedWidgetState();
}

class _SocialEmbedWidgetState extends ConsumerState<SocialEmbedRenderer> {
  late WebViewController controller;
  double height = 0.0;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    final bgColor = _getBgColor();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(bgColor)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) async {
        final h = await controller.runJavaScriptReturningResult(
            'document.documentElement.scrollHeight');
        height = double.tryParse(h.toString()) ?? 700;
        loaded = true;
        setState(() {});
      }))
      ..loadRequest(Uri.dataFromString(
        _getEmbedData(widget.platform, widget.data),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ));
  }

  String _getEmbedData(String? platform, String data) {
    final isDark = ref.read(isDarkMode(context));
    switch (platform) {
      case 'facebook':
        return _facebookRender(data);
      case 'twitter':
        return _xRender(data, isDark);
      case 'instagram':
        return _instagramEmbed(data);
      default:
        return _othersRender(data);
    }
  }

  Color _getBgColor() {
    return ref.read(isDarkMode(context)) ?? false
        ? const Color(0xff303030)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? const Center(child: AppLoader())
        : InkWell(
            onTap: () {
              final link = getLinksFromString(widget.data);
              if (link != null) {
                AppUtil.openLink(link);
              }
            },
            child: IgnorePointer(
              child: SizedBox(
                height: height,
                child: WebViewWidget(controller: controller),
              ),
            ),
          );
  }

  static String _xRender(String data, bool isDarkMode) {
    final theme = isDarkMode ? 'dark' : 'light';
    return """<!DOCTYPE html>
      <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='margin: 0; padding: 0;'>
        <blockquote class="twitter-tweet" data-theme="$theme">$data</blockquote> 
        <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
      </body>
      </html>""";
  }

  static String _facebookRender(String data) {
    return """<!DOCTYPE html>
      <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='margin: 0; padding: 0;'>
        <iframe src="$data" width="device-width" height="450" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>
      </body>
      </html>""";
  }

  static String _othersRender(String data) {
    return """<!DOCTYPE html>
      <html>
      <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width, viewport-fit=cover">
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='margin: 0; padding: 0;'>
        <div>$data</div>
      </body>
      </html>""";
  }

  static String _instagramEmbed(String source) {
    return '''<!doctype html>
      <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
      </head>
      <body>
        $source
        <script async src="https://www.instagram.com/embed.js"></script>
      </body>
      </html>''';
  }

  static String? getLinksFromString(String text) {
    final regex = RegExp(r'href="([^"]+)"');
    final matches = regex.allMatches(text);
    return matches.isNotEmpty ? matches.last.group(1) : null;
  }
}

class QuoteRenderer extends StatelessWidget {
  final String quote;
  const QuoteRenderer({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: IntrinsicHeight(
        child: Row(
          children: [
            VerticalDivider(
                color: Theme.of(context).primaryColor, width: 20, thickness: 2),
            Expanded(
                child: Text(
              HtmlUnescape().convert(parse(quote).documentElement!.text),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
