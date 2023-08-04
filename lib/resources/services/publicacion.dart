import 'dart:async';
import 'dart:convert';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/comentarioPerson.dart';
import 'package:flutter_maps_adv/models/comentarios.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/widgets/comment_pulbicacion.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PublicacionService {
  late Publicacion publicacionSeleccionada;
  final Publicacion publError = Publicacion(
    titulo: '',
    contenido: '',
    color: '',
    ciudad: '',
    barrio: '',
    isPublic: false,
    usuario: '',
    imgAlerta: '',
    nombreUsuario: '',
    isLiked: false,
    latitud: 0,
    longitud: 0,
  );

  Future<List<Publicacion>> getPublicacionesAll(
      {int publicationNext = 0}) async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/publicacion/cercanas?desde=$publicationNext');

      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });

      final publicacionesData = json.decode(resp.body);
      final publicacionesResp = PublicacionResponse.fromMap(publicacionesData);
      return publicacionesResp.publicacion;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<Publicacion>> getPublicacionesUsuario() async {
    final uri = Uri.parse('${Environment.apiUrl}/publicacion');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });

    final publicacionesData = json.decode(resp.body);
    final publicacionesResp = PublicacionResponse.fromMap(publicacionesData);
    return publicacionesResp.publicacion;
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
    bool isPublic,
    bool isLiked,
    String usuario,
    String nombreUsuario,
    List<String>? imagePaths,
  ) async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      final publicacion = Publicacion(
        titulo: titulo,
        contenido: descripcion,
        color: color,
        ciudad: placemarks[0].locality == null
            ? 'S/N'
            : placemarks[0].locality! == ""
                ? 'S/N'
                : placemarks[0].locality!,
        barrio: placemarks[0].street == null
            ? 'S/N'
            : placemarks[0].street! == ""
                ? 'S/N'
                : placemarks[0].street!,
        isPublic: isPublic,
        usuario: usuario,
        imgAlerta: imgAlerta,
        isLiked: isLiked,
        latitud: position.latitude,
        longitud: position.longitude,
        nombreUsuario: nombreUsuario,
      );

      final uri = Uri.parse('${Environment.apiUrl}/publicacion');

      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
        body: json.encode(publicacion.toMap()),
      );

      final decodedData = json.decode(resp.body);
      final publicacionResp = Publicacion.fromMap(decodedData['publicacion']);

      if (imagePaths!.isNotEmpty) {
        final publicacionResp2 = await uploadImages(
            publicacionResp.uid!, publicacion.titulo, imagePaths);

        return publicacionResp2;
      }

      return publicacionResp;
    } catch (e) {
      print('Error: $e');
      return publError;
    }
  }

  Future<Publicacion> uploadImages(
      String uid, String titulo, List<String> imagePaths) async {
    try {
      final List<String> uploadedImageUrls = [];
      late Publicacion secureUrlP;

      for (var imagePath in imagePaths) {
        final imageUploadRequest = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Environment.apiUrl}/publicacion/listaArchivos/$uid/$titulo'),
        );

        final file = await http.MultipartFile.fromPath('archivo', imagePath);
        imageUploadRequest.files.add(file);

        final streamResponse = await imageUploadRequest.send();
        final resp = await http.Response.fromStream(streamResponse);

        if (resp.statusCode != 200 && resp.statusCode != 201) {
          throw Exception('Error uploading images: ${resp.body}');
        }

        final decodedData = json.decode(resp.body);
        secureUrlP = Publicacion.fromMap(decodedData['publicacion']);

        uploadedImageUrls.add(secureUrlP.imgAlerta);
      }

      return secureUrlP;
    } catch (e) {
      print('Error: $e');
      return publError;
    }
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
      return publError;
    }
  }

  Future<List<Comentario>> getAllComments(String uid) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/comentarios/${uid}');

      final resp = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
      );

      final decodedData = json.decode(resp.body);
      final commentResp = ComentarioResponse.fromJson(decodedData);
      return commentResp.comentarios;
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<Comentario> toggleLikeComentario(String uid) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/comentarios/like/${uid}');

      final resp = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
      );

      final decodedData = json.decode(resp.body);

      if (decodedData.containsKey('comentario') &&
          decodedData['comentario'] != null) {
        final commentResp = Comentario.fromJson(decodedData['comentario']);
        return commentResp;
      } else {
        throw Exception('Error: Publicacion data not available.');
      }
    } catch (e) {
      throw Exception('Error: Failed to toggle like on comentario.');
    }
  }

  Future<ComentarioPerson> createComentario(
      String contenido, String publicacionId) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/comentarios');

      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
        body: json.encode({
          'contenido': contenido,
          'publicacionId': publicacionId,
        }),
      );
      final decodedData = json.decode(resp.body);
      final commentResp = ComentarioPersonResponse.fromJson(decodedData);
      return commentResp.comentario;
    } catch (e) {
      throw Exception('Error: Failed to create comentario.');
    }
  }
}
