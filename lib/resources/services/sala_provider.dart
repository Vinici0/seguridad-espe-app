import 'dart:async';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;

// class SalasProvider2 {
//   // late Usuario usuarioPara; // TODO: Importante para el chat privado
//   // late Sala salaSeleccionada;

//   final List<Sala> salas = [];

//   Future<List<Sala>> getSalesAll() async {
//     final uri = Uri.parse('${Environment.apiUrl}/salas/obtener-salas-usuario');
//     final resp = await http.get(uri, headers: {
//       'Content-Type': 'application/json',
//       'x-token': await AuthService.getToken() as String,
//     });
//     final salesResp = SalesResponse.fromJson(resp.body);

//     this.salas.addAll(salesResp.salas);
//     return salesResp.salas;
//   }

//   Future<Sala> createSala(String nombre) async {
//     final uri = Uri.parse('${Environment.apiUrl}/salas');
//     final resp = await http.post(uri,
//         headers: {
//           'Content-Type': 'application/json',
//           'x-token': await AuthService.getToken() as String,
//         },
//         body: '{"nombre":"$nombre"}');
//     final salaResp = Sala.fromJson(resp.body);
//     this.salas.add(salaResp);
//     return salaResp;
//   }
// }
