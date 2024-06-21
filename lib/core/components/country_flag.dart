import 'package:flutter/material.dart';

import 'network_image.dart';

class CountryFlag extends StatelessWidget {
  const CountryFlag({
    super.key,
    required this.countryCode,
  });

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final url = 'https://flagsapi.com/$countryCode/flat/64.png';
    return SizedBox(
      width: 50,
      height: 50,
      child: NetworkImageWithLoader(
        url,
        fit: BoxFit.contain,
        radius: 4,
      ),
    );
  }
}
