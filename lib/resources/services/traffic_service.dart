import 'dart:convert';

import 'package:flutter_maps_adv/models/places_models.dart';
import 'package:flutter_maps_adv/models/traffic_response.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

const accessToken =
    "pk.eyJ1IjoiY2lyaWxvMTAiLCJhIjoiY2w0cWR0bWZpMGp5bTNrczh4cGdnNm94eiJ9.aVONvx-pzUp1Plq-oz-_XQ";

class TrafficService {
  final String _baseTrafficUrl = 'api.mapbox.com';

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';

    final queryParams = {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': 'false',
      'access_token': accessToken,
    };
    final url = Uri.https(_baseTrafficUrl,
        'directions/v5/mapbox/driving/$coorsString', queryParams);

    final response = await http.get(
      url,
    );
    final decodedData = json.decode(response.body);
    final data = TrafficResponse.fromMap(decodedData);
    return data;
  }

  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    final queryParams = {
      'access_token': accessToken,
      'autocomplete': 'true',
      'proximity': '${proximity.longitude},${proximity.latitude}',
      'language': 'es',
      "limit": "5",
      "country": "ec"
    };

    final url = Uri.https(_baseTrafficUrl,
        '/geocoding/v5/mapbox.places/mapbox.places/$query.json', queryParams);

    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final placesResponse = PlacesResponse.fromJson(decodedData.data);
    return placesResponse.features;
  }
}
