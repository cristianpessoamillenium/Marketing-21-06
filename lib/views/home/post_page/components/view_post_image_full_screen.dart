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
