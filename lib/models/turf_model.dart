class Turf {
  final String id;
  final String name;
  final String location;
  final String rating;
  final String price;
  final List<String> tags;
  final bool isOpen;
  final String? imagePath;

  Turf({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.tags,
    required this.isOpen,
    this.imagePath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Turf && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
