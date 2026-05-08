class CommentModel {
  const CommentModel({
    required this.id,
    required this.text,
    required this.authorName,
    required this.createdAt,
  });

  final int id;
  final String text;
  final String authorName;
  final DateTime createdAt;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}