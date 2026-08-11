class Livro {
  final int? id;
  final String titulo;
  final int autorId;

  Livro({this.id, required this.titulo, required this.autorId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'titulo': titulo, 'autorId': autorId};
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(id: map['id'], titulo: map['titulo'], autorId: map['autorId']);
  }
}
