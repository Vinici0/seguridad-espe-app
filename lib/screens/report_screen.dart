import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_maps_adv/helpers/page_route.dart';

import 'package:flutter_maps_adv/screens/report_detalle_screen.dart';

class ReportScreen extends StatelessWidget {
  static const String reportRoute = 'denunciar';

  static const List<String> reportTitles = [
    'Violencia, abuso y explotación criminal',
    'Odio y acoso',
    'Suicidio y autolesión',
    'Trastornos alimentarios e imagen corporal',
    'Actividades y retos peligrosos',
    'Desnudez o contenido sexual',
    'Contenido impactante y explícito',
    'Información falsa',
    'Comportamiento engañoso y spam',
    'Actividades y mercancías reguladas',
    'Fraudes y estafas',
    'Divulgación de datos personales',
    'Falsificaciones y propiedad intelectual',
    'Otro',
  ];

  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Seleccionar motivo de la denuncia',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: List.generate(reportTitles.length, (index) {
          return _CardReport(
            title: reportTitles[index],
            subtitle: '', // Puedes dejar el subtítulo en blanco aquí
            icon: Icons.report,
          );
        }),
      ),
    );
  }
}

class _CardReport extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _CardReport({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationBloc = BlocProvider.of<NotificationBloc>(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black87),
        onTap: () {
          notificationBloc.add(
            CurrentTextReportEvent(title),
          );
          _navigateToReport(context, title);
        },
      ),
    );
  }

  void _navigateToReport(BuildContext context, String title) {
    Navigator.of(context)
        .push(CreateRoute.createRoute(const ReportDetalleScreen()));
  }
}
