import 'package:flutter/material.dart';

import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';
import '../../../core/models/author.dart';
import '../../../core/routes/app_routes.dart';

class AuthorTile extends StatelessWidget {
  const AuthorTile({
    super.key,
    required this.data,
  });

  final AuthorData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppDefaults.borderRadius,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.authorPage,
            arguments: data,
          ),
          child: SizedBox(
            width: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Avatar(data: data),
                AppSizedBox.h5,
                Text(
                  data.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.data,
  });

  final AuthorData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).cardColor, width: 1),
        boxShadow: AppDefaults.boxShadow,
        shape: BoxShape.circle,
      ),
      child: ClipOval(child: NetworkImageWithLoader(data.avatarUrlHD)),
    );
  }
}
