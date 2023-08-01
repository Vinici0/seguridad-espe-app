import 'dart:convert';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/places_models.dart';
import 'package:flutter_maps_adv/models/traffic_response.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

const accessToken =
    "pk.eyJ1IjoiY2lyaWxvMTAiLCJhIjoiY2w0cWR0bWZpMGp5bTNrczh4cGdnNm94eiJ9.aVONvx-pzUp1Plq-oz-_XQ";

class TrafficService {
  final String _baseTrafficUrl = 'api.mapbox.com';

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    try {
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

      final response = await http.get(url);
      final decodedData = json.decode(response.body);
      final data = TrafficResponse.fromMap(decodedData);
      return data;
    } catch (error) {
      print('Error getting coors: $error');
      return TrafficResponse(routes: [], waypoints: [], code: '', uuid: '');
    }
  }

  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    try {
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
      final placesResponse = PlacesResponse.fromJson(response.body);
      return placesResponse.features;
    } catch (error) {
      print('Error getting query results: $error');
      return [];
    }
  }

  Future<List<Ubicacion>> getResultsByQueryUbicacion(String query) async {
    final uri = Uri.parse('${Environment.apiUrl}/buscar/ubicaciones/$query');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });

    print("resp: ${resp.body}");
    final ubicacionesData = json.decode(resp.body);
    final ubicaciones = UbicacionResponse.fromMap(ubicacionesData);
    return ubicaciones.ubicacion;
  }

  //put ubcacion add
  Future<Ubicacion> addUbicacionByUser(String idUbicacion) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/ubicaciones/$idUbicacion');

      final resp = await http.put(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });

      final ubicacionData = json.decode(resp.body);
      final ubicacion = Ubicacion.fromMap(ubicacionData);
      return ubicacion;
    } catch (e) {
      print('Error adding ubicacion: $e');
      rethrow;
    }
  }

  // delete ubcacion add
  Future<bool> deleteUbicacionByUser(String idUbicacion) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/ubicaciones/$idUbicacion');

      final resp = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });

      return true;
    } catch (e) {
      print('Error adding ubicacion: $e');
      return false;
    }
  }
}
