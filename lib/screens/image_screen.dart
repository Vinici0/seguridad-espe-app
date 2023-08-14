import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';

class ImageScreen extends StatelessWidget {
  static const routeName = 'image-screen';
  const ImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publicactionBloc = BlocProvider.of<PublicationBloc>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 47, 58),
      appBar: AppBar(
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF111b21),
      ),
      body: Swiper(
        pagination: const SwiperPagination(),
        itemCount: publicactionBloc.state.currentPublicacion!.imagenes!.length,
        itemBuilder: (BuildContext context, int index) {
          return _ImageItem(
            index: index,
          );
        },
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  final int index;
  const _ImageItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publicactionBloc = BlocProvider.of<PublicationBloc>(context);
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            "${Environment.apiUrl}/uploads/publicaciones/${publicactionBloc.state.currentPublicacion!.uid!}?imagenIndex=${publicactionBloc.state.currentPublicacion!.imagenes![index]}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
