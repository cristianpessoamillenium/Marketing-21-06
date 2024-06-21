import 'package:flutter/material.dart';

import '../../../core/components/network_image.dart';
import '../../../core/models/author.dart';
import '../../../core/routes/app_routes.dart';

class AuthorListTile extends StatelessWidget {
  const AuthorListTile({
    super.key,
    required this.author,
  });

  final AuthorData author;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 50,
          height: 50,
          child: NetworkImageWithLoader(author.avatarUrlHD),
        ),
      ),
      title: Text(author.name),
      subtitle: Text(author.description.isEmpty
          ? 'No description provided'
          : author.description),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.authorPage, arguments: author);
      },
    );
  }
}
