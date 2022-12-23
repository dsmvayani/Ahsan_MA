class Client {
  String id;
  String name;

  Client({required this.id, required this.name});
  factory Client.fromJson(Map<String, dynamic> json) {
    return new Client(
        id: json['id'], name: json['name']);
  }
}