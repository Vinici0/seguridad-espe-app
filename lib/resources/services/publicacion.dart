import 'dart:async';
import 'dart:convert';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/publication.dart';

import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PublicacionService {
  late Publicacion publicacionSeleccionada;

  Future<List<Publicacion>> getPublicacionesAll() async {
    final uri = Uri.parse('${Environment.apiUrl}/publicacion/cercanas');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });

    final publicacionesData = json.decode(resp.body);
    final publicacionesResp = publicacionesData['publicaciones'];
    List<Publicacion> publicaciones = [];
    for (var publicacion in publicacionesResp) {
      publicaciones.add(Publicacion.fromMap(publicacion));
    }
    return publicaciones;
  }

  //update publicacion
  Future<Publicacion> updatePublicacion(String uid, bool isLiked) async {
    final uri = Uri.parse('${Environment.apiUrl}/publicacion/${uid}');

    final resp = await http.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
        body: json.encode({
          'isLiked': isLiked,
        }));

    final decodedData = json.decode(resp.body);
    final publicacionResp = Publicacion.fromMap(decodedData['publicacion']);
    return publicacionResp;
  }

  Future<Publicacion> createPublicacion(
    String titulo,
    String descripcion,
    String color,
    String imgAlerta,
    bool isLiked,
    bool isPublic,
    String usuario,
    List<String>? imagePaths,
  ) async {
    Position position = await Geolocator.getCurrentPosition();

    final publicacion = Publicacion(
      titulo: titulo,
      contenido: descripcion,
      color: color,
      ciudad: "Luz de America",
      barrio: 'S/N',
      isPublic: isPublic,
      usuario: usuario,
      imgAlerta: imgAlerta,
      isLiked: isLiked,
      latitud: position.latitude,
      longitud: position.longitude,
    );

    final uri = Uri.parse('${Environment.apiUrl}/publicacion');

    final resp = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
        body: json.encode(publicacion.toMap()));

    final decodedData = json.decode(resp.body);
    final publicacionResp = Publicacion.fromMap(decodedData['publicacion']);

    if (imagePaths != null) {
      final publicacionResp2 = await uploadImages(
          publicacionResp.uid!, publicacion.titulo, imagePaths);

      return publicacionResp2;
    }

    return publicacionResp;
  }

  Future<Publicacion> uploadImages(
      String uid, String titulo, List<String> imagePaths) async {
    final List<String> uploadedImageUrls = [];
    late Publicacion secureUrlP;

    for (var imagePath in imagePaths) {
      final imageUploadRequest = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Environment.apiUrl}/publicacion/listaArchivos/$uid/$titulo'));

      final file = await http.MultipartFile.fromPath('archivo', imagePath);
      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salió mal');
        print(resp.body);
        throw Exception('Error: ${resp.body}');
      }

      final decodedData = json.decode(resp.body);
      secureUrlP = Publicacion.fromMap(decodedData['publicacion']);

      uploadedImageUrls.add(secureUrlP.imgAlerta);
    }
    return secureUrlP;
  }

//router.put("/like2/:id", validarJWT, likePublicacion);
  Future<Publicacion> likePublicacion(String uid) async {
    final uri = Uri.parse('${Environment.apiUrl}/publicacion/like2/${uid}');

    final resp = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      },
    );

    final decodedData = json.decode(resp.body);

    if (decodedData.containsKey('publicacion') &&
        decodedData['publicacion'] != null) {
      final publicacionResp = Publicacion.fromMap(decodedData['publicacion']);
      return publicacionResp;
    } else {
      throw Exception('Error: Publicacion data not available.');
    }
  }
}
