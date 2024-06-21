// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class AppVideo extends StatefulWidget {
  const AppVideo({
    super.key,
    required this.url,
    required this.type,
    this.thumbnail,
    required this.aspectRatio,
  });
  final String url;
  final String type;
  final String? thumbnail;
  final double aspectRatio;

  @override
  State<AppVideo> createState() => _AppVideoState();
}

class _AppVideoState extends State<AppVideo> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
        playVideoFrom: widget.type == 'network'
            ? PlayVideoFrom.network(widget.url)
            : widget.type == 'vimeo'
                ? PlayVideoFrom.vimeo(widget.url)
                : PlayVideoFrom.youtube(widget.url),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ))
      ..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
      frameAspectRatio: widget.aspectRatio,
      videoAspectRatio: widget.aspectRatio,
      controller: controller,
      alwaysShowProgressBar: true,
      videoThumbnail: widget.thumbnail == null
          ? null
          : DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(widget.thumbnail!),
            ),
    );
  }
}
