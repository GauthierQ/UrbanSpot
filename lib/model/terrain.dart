// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    required this.terrain,
  });

  Map<String, Terrain> terrain;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    terrain: Map.from(json["Terrain"]).map((k, v) => MapEntry<String, Terrain>(k, Terrain.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "Terrain": Map.from(terrain).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Terrain {
  Terrain({
    required this.adresse,
    required this.cp,
    required this.description,
    required this.etat,
    required this.id,
    required this.img,
    required this.latitude,
    required this.longitude,
    required this.nom,
    //required this.ville,
  });

  String adresse;
  int cp;
  String description;
  int etat;
  int id;
  String img;
  double latitude;
  double longitude;
  String nom;
  //Ville ville;

  factory Terrain.fromJson(Map<String, dynamic> json) => Terrain(
    adresse: json["adresse"],
    cp: json["cp"],
    description: json["description"],
    etat: json["etat"],
    id: json["id"],
    img: json["img"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    nom: json["nom"],
   // ville: villeValues.map[json["ville"]],
  );

  Map<String, dynamic> toJson() => {
    "adresse": adresse,
    "cp": cp,
    "description": description,
    "etat": etat,
    "id": id,
    "img": img,
    "latitude": latitude,
    "longitude": longitude,
    "nom": nom,
    //"ville": villeValues.reverse[ville],
  };
}

enum Ville { RENNES, VERN_SUR_SEICHE, IUGHVBJ }
/*
final villeValues = EnumValues({
  "iughvbj": Ville.IUGHVBJ,
  "Rennes": Ville.RENNES,
  "Vern sur seiche": Ville.VERN_SUR_SEICHE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}*/