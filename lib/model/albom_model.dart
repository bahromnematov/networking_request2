
class AlbomModel {
  int userId;
  int id;
  String title;

  AlbomModel({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory AlbomModel.fromJson(Map<String, dynamic> json) => AlbomModel(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
  };
}
