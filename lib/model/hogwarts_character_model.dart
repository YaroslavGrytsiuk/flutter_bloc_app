class HogwartsCharacterModel {
  final String id;
  final String name;
  final List<String> alternateNames;
  final String species;
  final String gender;
  final String house;
  final String? dateOfBirth;
  final int? yearOfBirth;
  final bool wizard;
  final String ancestry;
  final String eyeColour;
  final String hairColour;
  final Wand wand;
  final String patronus;
  final bool hogwartsStudent;
  final bool hogwartsStaff;
  final String actor;
  final List<String> alternateActors;
  final bool alive;
  final String image;

  HogwartsCharacterModel({
    required this.id,
    required this.name,
    required this.alternateNames,
    required this.species,
    required this.gender,
    required this.house,
    this.dateOfBirth,
    this.yearOfBirth,
    required this.wizard,
    required this.ancestry,
    required this.eyeColour,
    required this.hairColour,
    required this.wand,
    required this.patronus,
    required this.hogwartsStudent,
    required this.hogwartsStaff,
    required this.actor,
    required this.alternateActors,
    required this.alive,
    required this.image,
  });

  factory HogwartsCharacterModel.fromJson(Map<String, dynamic> json) {
    return HogwartsCharacterModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      alternateNames: List<String>.from(json['alternate_names'] ?? []),
      species: json['species'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      house: json['house'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String?,
      yearOfBirth: json['yearOfBirth'] as int?,
      wizard: json['wizard'] as bool? ?? false,
      ancestry: json['ancestry'] as String? ?? '',
      eyeColour: json['eyeColour'] as String? ?? '',
      hairColour: json['hairColour'] as String? ?? '',
      wand: Wand.fromJson(json['wand'] ?? {}),
      patronus: json['patronus'] as String? ?? '',
      hogwartsStudent: json['hogwartsStudent'] as bool? ?? false,
      hogwartsStaff: json['hogwartsStaff'] as bool? ?? false,
      actor: json['actor'] as String? ?? '',
      alternateActors: List<String>.from(json['alternate_actors'] ?? []),
      alive: json['alive'] as bool? ?? false,
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alternate_names': alternateNames,
      'species': species,
      'gender': gender,
      'house': house,
      'dateOfBirth': dateOfBirth,
      'yearOfBirth': yearOfBirth,
      'wizard': wizard,
      'ancestry': ancestry,
      'eyeColour': eyeColour,
      'hairColour': hairColour,
      'wand': wand.toJson(),
      'patronus': patronus,
      'hogwartsStudent': hogwartsStudent,
      'hogwartsStaff': hogwartsStaff,
      'actor': actor,
      'alternate_actors': alternateActors,
      'alive': alive,
      'image': image,
    };
  }
}

class Wand {
  final String wood;
  final String core;
  final double? length;

  Wand({required this.wood, required this.core, this.length});

  factory Wand.fromJson(Map<String, dynamic> json) {
    return Wand(wood: json['wood'] as String? ?? '', core: json['core'] as String? ?? '', length: json['length']?.toDouble());
  }

  Map<String, dynamic> toJson() {
    return {'wood': wood, 'core': core, 'length': length};
  }
}
