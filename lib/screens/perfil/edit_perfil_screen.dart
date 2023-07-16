import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/screens/perfil/edit_nombre.dart';
import 'package:flutter_maps_adv/screens/perfil/edit_telefono.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPerfilScreen extends StatefulWidget {
  static const String editPerfilroute = 'editPerfil';
  const EditPerfilScreen({Key? key}) : super(key: key);

  @override
  State<EditPerfilScreen> createState() => _EditPerfilScreenState();
}

class _EditPerfilScreenState extends State<EditPerfilScreen> {
  final picker = ImagePicker();
  File? _imageFile;
  AuthBloc authBloc = AuthBloc();
  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: false,
          title: const Text(
            'Editar Perfil',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      //un circulo con la foto
                      GestureDetector(
                        onTap: () {
                          if (!state.usuario!.google) {
                            _seleccionarFoto();
                          }
                        },
                        child: state.usuario!.google == true
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(state.usuario!.img!),
                              )
                            : state.usuario!.img == null
                                ? const CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('assets/no-image.png'),
                                  )
                                : state.usuario!.google == true
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            NetworkImage(state.usuario!.img!),
                                      )
                                    : _imageFile == null
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                '${Environment.apiUrl}/uploads/usuario/usuarios/${state.usuario!.uid}'),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                FileImage(_imageFile!),
                                          ),
                      ),
                      if (!state.usuario!.google)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(
                  color: Colors.black26,
                ),
                //el
                ListTile(
                  //nombre
                  title: const Text(
                    'Nombres',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(state.usuario!.nombre!,
                      style: const TextStyle(fontSize: 16)),
                  //flecha para editar
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(
                        context, EditNombreScreen.editNombreroute);
                  },
                ),
                const Divider(
                  color: Colors.black26,
                ),
                ListTile(
                  //correo
                  title: const Text(
                    'Correo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(state.usuario!.email!,
                      style: const TextStyle(fontSize: 16)),
                  onTap: () {
                    // Navigator.pushNamed(context, 'editPerfil');
                  },
                ),

                //telefono
                const Divider(
                  color: Colors.black26,
                ),
                //el
                ListTile(
                  title: const Text(
                    'Telefono',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(state.usuario!.telefono!, //telefono
                      style: const TextStyle(fontSize: 16)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(
                        context, EditTelefonoScreen.editTelefonoeroute);
                  },
                ),
                const Divider(
                  color: Colors.black26,
                ),
                //el
                //agregar un direcion
                ListTile(
                  title: const Text('Direcciones', //direccion
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Agregar una nueva direccion', //agregar
                      style: TextStyle(fontSize: 16)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(context, 'lugares');
                  },
                ),
                const Divider(
                  color: Colors.black26,
                ),
                //eliminar cuenta

                ListTile(
                  title: const Text('Eliminar Cuenta',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Eliminar cuenta de usuario'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigator.pushNamed(context, 'editPerfil');
                  },
                ),
                //mensaje donde diga que esta informacion es privada
                const Divider(
                  color: Colors.black26,
                ),
                //el
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Esta informacion es privada y no sera compartida con nadie',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ],
            );
          },
        ));
  }

  void _seleccionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await authBloc.updateUsuarioImage(imageFile.path);
    }
    setState(() {});
  }
}
