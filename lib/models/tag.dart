class Tag {
  int? id;
  String name;

  Tag({this.id, required this.name});

  factory Tag.fromMap(Map<String, dynamic> json) => Tag(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
