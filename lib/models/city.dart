class City {
  final String name;
  final String delivery;

  City({
    required this.name,
    required this.delivery,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      delivery: json['delivery'],
    );
  }
}