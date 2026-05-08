class ClientModel {
  const ClientModel({
    required this.id,
    required this.name,
    required this.phone,
    this.comment,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String phone;
  final String? comment;
  final DateTime createdAt;

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      comment: json['comment'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    if (comment != null) 'comment': comment,
  };

  ClientModel copyWith({
    String? name,
    String? phone,
    String? comment,
  }) {
    return ClientModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      comment: comment ?? this.comment,
      createdAt: createdAt,
    );
  }
}