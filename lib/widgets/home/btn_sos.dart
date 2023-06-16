import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';

class BtnSOS extends StatelessWidget {
  const BtnSOS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const SizedBox()
            : const PositionedBtnSOS();
      },
    );
  }
}

class PositionedBtnSOS extends StatelessWidget {
  const PositionedBtnSOS({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.09,
      right: 16.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {},
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(219, 31, 31, 1), // Rojo transparente
                  Color.fromRGBO(220, 34, 34, 0.893), // Rojo más transparente
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.5),
                  spreadRadius: 9,
                  blurRadius: 5,
                  // offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.3 / 2),
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.30,
                alignment: Alignment.center,
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
