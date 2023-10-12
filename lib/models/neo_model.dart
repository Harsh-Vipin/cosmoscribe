class NeoModel {
  Links? links;
  int? elementCount;
  Map<String, List<NearEarthObject>>? nearEarthObjects;
  late final String? error;

  NeoModel({
    required this.links,
    required this.elementCount,
    required this.nearEarthObjects,
    this.error,
  });

  NeoModel.withError(String? errorMessage) {
    error = errorMessage;
  }

  factory NeoModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> links = json['links'];
    final Map<String, dynamic> nearEarthObjects = json['near_earth_objects'];

    return NeoModel(
      links: Links.fromJson(links),
      elementCount: json['element_count'],
      nearEarthObjects: nearEarthObjects.map((key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((item) => NearEarthObject.fromJson(item))
              .toList())),
    );
  }
}

class Links {
  final String? next;
  final String? previous;
  final String? self;

  Links({
    required this.next,
    required this.previous,
    required this.self,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      next: json['next'],
      previous: json['previous'],
      self: json['self'],
    );
  }
}

class NearEarthObject {
  final Links links;
  final String id;
  final String neoReferenceId;
  final String name;
  final String nasaJplUrl;
  final double absoluteMagnitudeH;
  final EstimatedDiameter estimatedDiameter;
  final bool isPotentiallyHazardousAsteroid;
  final List<CloseApproachData> closeApproachData;
  final bool isSentryObject;

  NearEarthObject({
    required this.links,
    required this.id,
    required this.neoReferenceId,
    required this.name,
    required this.nasaJplUrl,
    required this.absoluteMagnitudeH,
    required this.estimatedDiameter,
    required this.isPotentiallyHazardousAsteroid,
    required this.closeApproachData,
    required this.isSentryObject,
  });

  factory NearEarthObject.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> links = json['links'];
    final Map<String, dynamic> estimatedDiameter = json['estimated_diameter'];

    return NearEarthObject(
      links: Links.fromJson(links),
      id: json['id'],
      neoReferenceId: json['neo_reference_id'],
      name: json['name'],
      nasaJplUrl: json['nasa_jpl_url'],
      absoluteMagnitudeH: json['absolute_magnitude_h'].toDouble(),
      estimatedDiameter: EstimatedDiameter.fromJson(estimatedDiameter),
      isPotentiallyHazardousAsteroid: json['is_potentially_hazardous_asteroid'],
      closeApproachData: (json['close_approach_data'] as List<dynamic>)
          .map((item) => CloseApproachData.fromJson(item))
          .toList(),
      isSentryObject: json['is_sentry_object'],
    );
  }
}

class EstimatedDiameter {
  final Kilometers kilometers;
  final Meters meters;
  final Miles miles;
  final Feet feet;

  EstimatedDiameter({
    required this.kilometers,
    required this.meters,
    required this.miles,
    required this.feet,
  });

  factory EstimatedDiameter.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> kilometers = json['kilometers'];
    final Map<String, dynamic> meters = json['meters'];
    final Map<String, dynamic> miles = json['miles'];
    final Map<String, dynamic> feet = json['feet'];

    return EstimatedDiameter(
      kilometers: Kilometers.fromJson(kilometers),
      meters: Meters.fromJson(meters),
      miles: Miles.fromJson(miles),
      feet: Feet.fromJson(feet),
    );
  }
}

class Kilometers {
  final double estimatedDiameterMin;
  final double estimatedDiameterMax;

  Kilometers({
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
  });

  factory Kilometers.fromJson(Map<String, dynamic> json) {
    return Kilometers(
      estimatedDiameterMin: json['estimated_diameter_min'].toDouble(),
      estimatedDiameterMax: json['estimated_diameter_max'].toDouble(),
    );
  }
}

class Meters {
  final double estimatedDiameterMin;
  final double estimatedDiameterMax;

  Meters({
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
  });

  factory Meters.fromJson(Map<String, dynamic> json) {
    return Meters(
      estimatedDiameterMin: json['estimated_diameter_min'].toDouble(),
      estimatedDiameterMax: json['estimated_diameter_max'].toDouble(),
    );
  }
}

class Miles {
  final double estimatedDiameterMin;
  final double estimatedDiameterMax;

  Miles({
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
  });

  factory Miles.fromJson(Map<String, dynamic> json) {
    return Miles(
      estimatedDiameterMin: json['estimated_diameter_min'].toDouble(),
      estimatedDiameterMax: json['estimated_diameter_max'].toDouble(),
    );
  }
}

class Feet {
  final double estimatedDiameterMin;
  final double estimatedDiameterMax;

  Feet({
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
  });

  factory Feet.fromJson(Map<String, dynamic> json) {
    return Feet(
      estimatedDiameterMin: json['estimated_diameter_min'].toDouble(),
      estimatedDiameterMax: json['estimated_diameter_max'].toDouble(),
    );
  }
}

class CloseApproachData {
  final String closeApproachDate;
  final String closeApproachDateFull;
  final int epochDateCloseApproach;
  final RelativeVelocity relativeVelocity;
  final MissDistance missDistance;
  final String orbitingBody;

  CloseApproachData({
    required this.closeApproachDate,
    required this.closeApproachDateFull,
    required this.epochDateCloseApproach,
    required this.relativeVelocity,
    required this.missDistance,
    required this.orbitingBody,
  });

  factory CloseApproachData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> relativeVelocity = json['relative_velocity'];
    final Map<String, dynamic> missDistance = json['miss_distance'];

    return CloseApproachData(
      closeApproachDate: json['close_approach_date'],
      closeApproachDateFull: json['close_approach_date_full'],
      epochDateCloseApproach: json['epoch_date_close_approach'],
      relativeVelocity: RelativeVelocity.fromJson(relativeVelocity),
      missDistance: MissDistance.fromJson(missDistance),
      orbitingBody: json['orbiting_body'],
    );
  }
}

class RelativeVelocity {
  final String kilometersPerSecond;
  final String kilometersPerHour;
  final String milesPerHour;

  RelativeVelocity({
    required this.kilometersPerSecond,
    required this.kilometersPerHour,
    required this.milesPerHour,
  });

  factory RelativeVelocity.fromJson(Map<String, dynamic> json) {
    return RelativeVelocity(
      kilometersPerSecond: json['kilometers_per_second'],
      kilometersPerHour: json['kilometers_per_hour'],
      milesPerHour: json['miles_per_hour'],
    );
  }
}

class MissDistance {
  final String astronomical;
  final String lunar;
  final String kilometers;
  final String miles;

  MissDistance({
    required this.astronomical,
    required this.lunar,
    required this.kilometers,
    required this.miles,
  });

  factory MissDistance.fromJson(Map<String, dynamic> json) {
    return MissDistance(
      astronomical: json['astronomical'],
      lunar: json['lunar'],
      kilometers: json['kilometers'],
      miles: json['miles'],
    );
  }
}
