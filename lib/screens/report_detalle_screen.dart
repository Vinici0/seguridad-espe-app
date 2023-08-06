import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/helpers/type_report.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReportDetalleScreen extends StatelessWidget {
  static const String reportDetalleRoute = 'report_detalle';
  const ReportDetalleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> reportSpecifications =
        TypeReport().reportSpecifications;
    final args = ModalRoute.of(context)!.settings.arguments as String;
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
                      args,
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
                          reportSpecifications[args]!.length, (index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF6165FA),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    reportSpecifications[args]![index],
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
                _BtnReport(args: args),
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
                      color: Color(0xFF6165FA),
                      size: 24.0,
                    )
                  : MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: const Color(0xFF6165FA),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await publicationBloc.reportPublicationEvent(
                            publicationBloc.state.currentPublicacion!.uid!,
                            widget.args);

                        setState(() {
                          _isLoading = false;
                        });

                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, 'report_finish');
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
