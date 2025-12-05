class RadioStation {
  final String name;
  final String url;
  final String image;

  const RadioStation({
    required this.name,
    required this.url,
    required this.image,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      name: json['name'] as String,
      url: json['url'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'image': image};
  }
}
