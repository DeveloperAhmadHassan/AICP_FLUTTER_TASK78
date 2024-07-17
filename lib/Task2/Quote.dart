class Quote {
  final String id;
  final String quote;
  final String author;
  final String type;

  Quote({required this.id, required this.quote, required this.author, required this.type});

  factory Quote.fromJson(Map<String, dynamic> json) {
    print("Here");
    return Quote(
      id: "1",
      quote: json['quote'],
      author: json['author'],
      type: json['category']
    );
  }
}

