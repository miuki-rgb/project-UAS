class Announcement {
  final int id;
  final String title;
  final String content;
  final String type;
  final String? image;
  final DateTime? validUntil;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.image,
    this.validUntil,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
      image: json['image'],
      validUntil: json['valid_until'] != null ? DateTime.parse(json['valid_until']) : null,
    );
  }
}