

class CommentsModel {
  const CommentsModel(
      {required this.postId,
      required this.id,
      required this.name,
      required this.email,
      required this.body});

  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      postId: json['postId'] ?? "",
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      body: json['body'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['postId'] = postId;
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['body'] = body;
    return data;
  }
}
