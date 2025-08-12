class Vehicle {
  final String id;
  final String name;
  final String number;
  final String color;
  final String model;
  final int createdAt;
  final int updatedAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.number,
    required this.color,
    required this.model,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      name: json['_name'] ?? '',
      number: json['_number'] ?? '',
      color: json['_color'] ?? '',
      model: json['_model'].toString(),
      createdAt: json['_createdAt'] ?? 0,
      updatedAt: json['_updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "_name": name,
      "_number": number,
      "_color": color,
      "_model": model,
      "_createdAt": createdAt,
      "_updatedAt": updatedAt,
    };
  }
}
