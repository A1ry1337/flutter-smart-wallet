enum RequestStatus {
  newRequest,
  inProgress,
  done;

  static RequestStatus fromString(String value) => switch (value) {
    'NEW' => RequestStatus.newRequest,
    'IN_PROGRESS' => RequestStatus.inProgress,
    'DONE' => RequestStatus.done,
    _ => RequestStatus.newRequest,
  };

  String toApiString() => switch (this) {
    RequestStatus.newRequest => 'NEW',
    RequestStatus.inProgress => 'IN_PROGRESS',
    RequestStatus.done => 'DONE',
  };

  String get label => switch (this) {
    RequestStatus.newRequest => 'Новая',
    RequestStatus.inProgress => 'В работе',
    RequestStatus.done => 'Завершена',
  };
}

class RequestModel {
  const RequestModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.clientId,
    required this.clientName,
    this.clientPhone,
    this.createdByName,
    required this.createdAt,
    required this.updatedAt,
    this.commentCount = 0,
  });

  final int id;
  final String title;
  final String? description;
  final RequestStatus status;
  final int clientId;
  final String clientName;
  final String? clientPhone;
  final String? createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int commentCount;

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      status: RequestStatus.fromString(json['status'] as String? ?? 'NEW'),
      clientId: (json['clientId'] as num?)?.toInt() ?? 0,
      clientName: json['clientName'] as String? ?? '',
      clientPhone: json['clientPhone'] as String?,
      createdByName: json['createdByName'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
    );
  }
}