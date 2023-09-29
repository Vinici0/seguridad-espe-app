import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_maps_adv/helpers/page_route.dart';
import 'package:flutter_maps_adv/helpers/type_report.dart';
import 'package:flutter_maps_adv/screens/report_finish_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReportDetalleScreen extends StatelessWidget {
  static const String reportDetalleRoute = 'report_detalle';
  const ReportDetalleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> reportSpecifications =
        TypeReport().REPORT_SPECIFICATIONS;
    final notificationBloc = BlocProvider.of<NotificationBloc>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: false,
          title: const Text(
            'Denunciar',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //pegado a la derecha
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notificationBloc.state.currentText,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Queda prohibido lo siguiente:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //listar segun el titulo
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                          reportSpecifications[
                                  notificationBloc.state.currentText]!
                              .length, (index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF7ab466),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    reportSpecifications[notificationBloc
                                        .state.currentText]![index],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                _BtnReport(args: notificationBloc.state.currentText),
              ],
            )));
  }
}

class _BtnReport extends StatefulWidget {
  final String args;
  const _BtnReport({Key? key, required this.args}) : super(key: key);

  @override
  __BtnReportState createState() => __BtnReportState();
}

class __BtnReportState extends State<_BtnReport> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          AbsorbPointer(
            absorbing:
                _isLoading, // Bloquear la interacción cuando isLoading es true
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              width: width * 0.95,
              height: 40,
              child: _isLoading
                  ? const SpinKitFadingCircle(
                      color: Color(0xFF7ab466),
                      size: 24.0,
                    )
                  : MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: const Color(0xFF7ab466),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final result =
                            await publicationBloc.reportPublicationEvent(
                                publicationBloc.state.currentPublicacion!.uid!,
                                widget.args);

                        //si ya se envio la denuncia que muestra el mensaje

                        setState(() {
                          _isLoading = false;
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(CreateRoute.createRoute(
                            const ReportFinishScreen()));
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
