class NearbyPlaces {
  // List<void>? htmlAttributions;
  List<Results>? results;
  String? status;

  NearbyPlaces({this.results, this.status});

  NearbyPlaces.fromJson(Map<String, dynamic> json) {
    // if (json['html_attributions'] != null) {
    //   // htmlAttributions = List<void>();
    //   json['html_attributions'].forEach((v) {
    //     htmlAttributions.add(void.fromJson(v));
    //   });
    // }
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Results {
  String? businessStatus;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  // OpeningHours? openingHours;
  // List<Photos>? photos;
  String? placeId;
  // PlusCode? plusCode;
  // double? rating;
  String? reference;
  String? scope;
  List<String>? types;
  // double? userRatingsTotal;
  String? vicinity;

  Results(
      {this.businessStatus,
      this.geometry,
      this.icon,
      this.iconBackgroundColor,
      this.iconMaskBaseUri,
      this.name,
      // this.openingHours,
      // this.photos,
      this.placeId,
      // this.plusCode,
      // this.rating,
      this.reference,
      this.scope,
      this.types,
      // this.userRatingsTotal,
      this.vicinity});

  Results.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    // openingHours = json['opening_hours'] != null
    //     ? OpeningHours.fromJson(json['opening_hours'])
    //     : null;
    // if (json['photos'] != null) {
    //   photos = <Photos>[];
    //   json['photos'].forEach((v) {
    //     photos!.add(Photos.fromJson(v));
    //   });
    // }
    placeId = json['place_id'];
    // plusCode =
    //     json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    // rating = json['rating'];
    reference = json['reference'];
    scope = json['scope'];
    types = json['types'].cast<String>();
    // userRatingsTotal = json['user_ratings_total'];
    vicinity = json['vicinity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_status'] = businessStatus;
    data['geometry'] = geometry!.toJson();
    data['icon'] = icon;
    data['icon_background_color'] = iconBackgroundColor;
    data['icon_mask_base_uri'] = iconMaskBaseUri;
    data['name'] = name;
    // data['opening_hours'] = openingHours.toJson();
    // data['photos'] = photos.map((v) => v.toJson()).toList();
    data['place_id'] = placeId;
    // data['plus_code'] = plusCode.toJson();
    // data['rating'] = rating;
    data['reference'] = reference;
    data['scope'] = scope;
    data['types'] = types;
    // data['user_ratings_total'] = userRatingsTotal;
    data['vicinity'] = vicinity;
    return data;
  }
}

class Geometry {
  Location? location;
  // Viewport viewport;

  Geometry({
    this.location,
  });

  Geometry.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    // viewport =
    //     json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location!.toJson();
    // data['viewport'] = viewport.toJson();
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

// class Viewport {
//   Location northeast;
//   Location southwest;

//   Viewport({this.northeast, this.southwest});

//   Viewport.fromJson(Map<String, dynamic> json) {
//     northeast =
//         json['northeast'] != null ? Location.fromJson(json['northeast']) : null;
//     southwest =
//         json['southwest'] != null ? Location.fromJson(json['southwest']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['northeast'] = northeast.toJson();
//     data['southwest'] = southwest.toJson();
//     return data;
//   }
// }

// class OpeningHours {
//   bool openNow;

//   OpeningHours({this.openNow});

//   OpeningHours.fromJson(Map<String, dynamic> json) {
//     openNow = json['open_now'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['open_now'] = openNow;
//     return data;
//   }
// }

// class Photos {
//   int height;
//   List<String> htmlAttributions;
//   String photoReference;
//   int width;

//   Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

//   Photos.fromJson(Map<String, dynamic> json) {
//     height = json['height'];
//     htmlAttributions = json['html_attributions'].cast<String>();
//     photoReference = json['photo_reference'];
//     width = json['width'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['height'] = height;
//     data['html_attributions'] = htmlAttributions;
//     data['photo_reference'] = photoReference;
//     data['width'] = width;
//     return data;
//   }
// }

// class PlusCode {
//   String compoundCode;
//   String globalCode;

//   PlusCode({this.compoundCode, this.globalCode});

//   PlusCode.fromJson(Map<String, dynamic> json) {
//     compoundCode = json['compound_code'];
//     globalCode = json['global_code'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['compound_code'] = compoundCode;
//     data['global_code'] = globalCode;
//     return data;
//   }
// }
