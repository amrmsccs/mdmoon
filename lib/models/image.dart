class Image {
  final String url;
  final bool isPrimary;

  Image({
    required this.url,
    required this.isPrimary,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['url'],
      isPrimary: json['is_primary'],
    );
  }
}


