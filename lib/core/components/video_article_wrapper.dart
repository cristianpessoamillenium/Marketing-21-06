import 'package:flutter/material.dart';

import '../constants/constants.dart';

class VideoArticleWrapper extends StatelessWidget {
  const VideoArticleWrapper({
    super.key,
    required this.isVideoArticle,
    required this.child,
  });

  final bool isVideoArticle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVideoArticle)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: AppDefaults.borderRadius,
                ),
                child: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
