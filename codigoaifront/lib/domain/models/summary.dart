class Summary {
  final String title;
  final String content;

  Summary({required this.title, required this.content});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      title: json['title'],
      content: json['content'],
    );
  }
}
