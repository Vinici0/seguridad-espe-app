import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/models/perfil.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class MenuScreen extends StatefulWidget {
  static const String salesroute = 'menu';

  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
    Position? currentPosition;
    String name = '';
    String ciudad = '';
    final _textController = new TextEditingController();
    final ImagePicker imgpicker = ImagePicker();
    List<String>? imagePaths;
    List<XFile>? imagefiles;
    bool isPressed = false;
    bool _estaEscribiendo = false;

    Future<void> _getCurrentLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition();
        final List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        final Placemark place = placemarks[0];
        // print(place);
        setState(() {
          currentPosition = position;
          name = place.street ?? '';
          ciudad = place.subAdministrativeArea ?? '';
        });
      } catch (e) {
        // Manejo de errores
      }
    }

    @override
    void initState() {
      super.initState();
      _getCurrentLocation();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 1,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/perroPerdido.jpg'),
          ),
          SizedBox(height: 20),
          Text(
            authBloc.state.usuario!.nombre,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          buildInfoRow(Icons.location_on, 'Dirección', Colors.black45, 14),
          Divider(height: 20, thickness: 2),
          buildInfoRow(Icons.phone, 'Teléfono', Colors.black45, 14),
          Divider(height: 20, thickness: 2),
          buildInfoRow(Icons.email, 'Correo', Colors.black45, 14),
          Divider(height: 20, thickness: 2),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoadingLoginScreen(),
                      transitionDuration: Duration(milliseconds: 0)));
            },
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(
      IconData icon, String text, Color textColor, double fontSize) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 10),
          Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
