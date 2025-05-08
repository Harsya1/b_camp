class Kamar {
  final int id;
  final String namaKamar;
  final String? deskripsi;
  final String gender;
  final String typeKamar;
  final String kategori;
  final String? gambar;
  final double harga;

  Kamar({
    required this.id,
    required this.namaKamar,
    this.deskripsi,
    required this.gender,
    required this.typeKamar,
    required this.kategori,
    this.gambar,
    required this.harga,
  });

  factory Kamar.fromJson(Map<String, dynamic> json) {
    return Kamar(
      id: json['id'],
      namaKamar: json['nama_kamar'],
      deskripsi: json['deskripsi'],
      gender: json['gender'],
      typeKamar: json['type_kamar'],
      kategori: json['kategori'],
      gambar: json['gambar'],
      harga: double.parse(json['harga'].toString()),
    );
  }
}