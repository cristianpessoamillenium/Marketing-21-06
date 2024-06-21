import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_audio/flutter_html_audio.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/controllers/html/html_extensions.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/app_utils.dart';

class ArticleHtmlConverter extends StatelessWidget {
  const ArticleHtmlConverter({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Html(
        data: article.content,
        shrinkWrap: false,
        style: {
          'body': Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(16.0),
            lineHeight: const LineHeight(1.4),
          ),
          'figure': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
          'table': Style(
            backgroundColor: Theme.of(context).cardColor,
          ),
          'tr': Style(
            border: const Border(bottom: BorderSide(color: Colors.grey)),
          ),
          'th': Style(
            padding: HtmlPaddings.all(6),
            backgroundColor: Colors.grey,
          ),
          'td': Style(
            padding: HtmlPaddings.all(6),
            alignment: Alignment.topLeft,
          ),
          'blockquote': Style(
            margin: Margins.only(left: 16),
          ),
        },
        extensions: [
          const TableHtmlExtension(),
          const SvgHtmlExtension(),
          const AudioHtmlExtension(),
          AppHtmlVideoExtension(),
          AppHtmlGalleryRender(),
          AppHtmlIframeExtension(),
          AppHtmlImageExtension(),
          AppHtmlBlockquoteExtension(),
          AppHtmlCodeExtension(),
        ],
        onLinkTap: (url, renderCtx, _) {
          if (url == null) {
            Fluttertoast.showToast(msg: 'No url found');
          } else {
            AppUtil.handleUrl(url);
          }
        },
      ),
    );
  }
}
