import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/publicacion.dart';

import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PublicacionService extends StateStreamableSource<Object?> {
  late Publicacion publicacionSeleccionada;

  List<String> imagePaths = [];
  List<Publicacion> publicaciones = [];

  late final StreamController<List<Publicacion>> _publicacionesController =
      StreamController<List<Publicacion>>.broadcast(sync: true);

  Stream<List<Publicacion>> get publicacionesStream =>
      _publicacionesController.stream;

  PublicacionService() {
    this.getPublicacionesAll();
  }

  Future<List<Publicacion>> getPublicacionesAll() async {
    final uri = Uri.parse('${Environment.apiUrl}/publicacion/cercanas');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });

    final publicacionesData = json.decode(resp.body);
    final publicacionesResp =
        (publicacionesData['publicaciones'] as List<dynamic>)
            .map((publicacion) => Publicacion.fromMap(publicacion))
            .toList();

    // print(publicacionesResp);
    this.publicaciones.addAll(publicacionesResp);
    _publicacionesController.add(publicacionesResp);
    return publicacionesResp;
  }

  Future<Publicacion> createPublicacion(
    String titulo,
    String descripcion,
    String color,
    String imgAlerta,
    bool isLiked,
    bool isPublic,
    String usuario,
  ) async {
    Position position = await Geolocator.getCurrentPosition();

    final List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    final publicacion = Publicacion(
      titulo: titulo,
      contenido: descripcion,
      color: color,
      ciudad: placemarks[0].locality ?? 'S/N',
      barrio: placemarks[0].street ?? 'S/N',
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
        body: json.encode(publicacion
            .toMap())); // Convertir el objeto publicacion a una cadena JSON

    final decodedData = json.decode(resp.body);
    final publicacionResp = Publicacion.fromMap(decodedData['publicacion']);
    // this.publicaciones.add(publicacionResp);
    // _publicacionesController.add(this.publicaciones);
    return publicacionResp;
  }

  Future<List<String>?> uploadImages(
      String uid, String titulo, List<String> imagePaths) async {
    final List<String> uploadedImageUrls = [];

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
        return null;
      }

      final decodedData = json.decode(resp.body);
      final secureUrl = Publicacion.fromMap(decodedData['publicacion']);

      uploadedImageUrls.add(secureUrl.imgAlerta);
    }

    return uploadedImageUrls;
  }

  // void updateSelectedProductImage(List<String> imagePaths, List<String> paths,
  //     String uid, String titulo) {
  //   this.publicacionSeleccionada.archivo = paths;
  // }

  @override
  FutureOr<void> close() {
    _publicacionesController.close();
  }

  @override
  bool get isClosed => _publicacionesController.isClosed;

  @override
  Object? get state => this.publicaciones;

  @override
  Stream<Object?> get stream => _publicacionesController.stream;

  @override
  void dispose() {
    _publicacionesController.close();
  }
}
