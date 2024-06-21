class WPAd {
  int id;
  String imageURL;
  String adTarget;
  bool isBanner;
  String size;
  WPAd({
    required this.id,
    required this.imageURL,
    required this.adTarget,
    required this.isBanner,
    required this.size,
  });

  factory WPAd.fromMap(Map<String, dynamic> map) {
    return WPAd(
      id: map['id']?.toInt() ?? 0,
      imageURL: map['thumbnail'] ?? '',
      adTarget: map['ad_target'] ?? '',
      isBanner: map['ad_size'] == 'Banner' ? true : false,
      size: map['ad_size'] ?? '',
    );
  }

  @override
  String toString() {
    return 'WPAd(id: $id, imageURL: $imageURL, adTarget: $adTarget, isBanner: $isBanner, size: $size)';
  }
}
