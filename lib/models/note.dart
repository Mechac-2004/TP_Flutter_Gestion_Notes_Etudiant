import 'tag.dart';

class Note {
  int? id;
  String content;
  List<Tag>? tags;

  Note({this.id, required this.content, this.tags});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json['id'],
        content: json['content'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
      };
}
