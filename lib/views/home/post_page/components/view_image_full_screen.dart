import 'package:flutter/material.dart';

import '../../../../core/components/network_image.dart';

class ViewImageFullScreen extends StatelessWidget {
  const ViewImageFullScreen({
    super.key,
    required this.url,
  });
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: InteractiveViewer(
          child: Hero(
            tag: url,
            child: NetworkImageWithLoader(
              url,
              radius: 0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class ViewImageDialog extends StatelessWidget {
  const ViewImageDialog({
    super.key,
    required this.url,
  });
  final String url;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: InteractiveViewer(
          child: NetworkImageWithLoader(
            url,
            radius: 0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
