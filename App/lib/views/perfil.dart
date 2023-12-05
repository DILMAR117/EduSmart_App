// ignore_for_file: avoid_print, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/conexion.dart';
import '../constants.dart';
import 'perfiledit.dart';
import 'verificarContraseña/verificarContrasena.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  final TextEditingController _telefonoController = TextEditingController();
  final  TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
   bool isLoading= true;
  final Conexion _conexion = Conexion();
  String? _token;
  String foto = "";
  String matricula = "";

  @override
  void initState(){
    _obtenerToken();
    isLoading =true;
    super.initState();
  }

  Future<void> _obtenerToken()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _token = token;
    });  
     await _conexion.getalumnoData(_token!);
        

     Future.delayed(Duration(seconds: 1), () {
    setState(() {
      _correoController.text = _conexion.userData!['correo'];
      _telefonoController.text =_conexion.userData!['telefono'];
      _contrasena.text = _conexion.userData!['contrasena'];
      foto = _conexion.userData!['foto'];
      matricula= _conexion.userData!['matricula'];
      isLoading = false;
    });
  });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [backgroundColor1, backgroundColor2],
            ),
          ),
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 130.0),
               _conexion.userData == null ? Visibility(
                  visible: isLoading, // Muestra el loading cuando isLoading es true
                  child: const  Center(
                    child: CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
                  ),
                ):
                Visibility(
                  visible: !isLoading,
                    child: Row(
                      children:  [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage('${_conexion.ip}/get-image/${_conexion.userData!['foto']}'), // Replace with your image path
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${_conexion.userData!['nombre']} ${_conexion.userData!['app']}\n ${_conexion.userData!['apm']}',
                          style:const TextStyle(
                            fontSize: 18.0,
                            color: blanco,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                     )
                  ),
                  
                     const SizedBox(height:0),
                    Container(
                        padding:
                            const EdgeInsets.only(top: 30.0, left: 0.0, right: 160.0),
                        height: 80.0,
                        width: 300.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: blanco,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(40.0)),
                          child: TextButton(
                            //al precionarlo indicamos la ruta al cual se va diriguir
                            onPressed: () {
                              final SizeTransition5 _transition =SizeTransition5(PerfilEdit(token: _token!,));
                              Navigator.push(context, _transition);
                              //print("Funciona");
                            },
                            child: const Center(
                              child: Text(
                                'Editar',
                                style: TextStyle(
                                    color: blanco,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        )
                        ),
                          SizedBox(height: 30,),
                      //Campo correo
                                    const Text(
                                        "Correo Electronico",
                                        style: TextStyle(
                                          color: blanco,
                                          fontWeight: FontWeight.bold,
                                        ),
                      
                                      ),
                        GestureDetector(
                          //Navegar a la vista correspondiente pasando la variable a editar en este caso el correo electronico
                          onTap: (){
                            final SizeTransition5 _transition =SizeTransition5(VerificarContrasena(
                            correo: _correoController.text,
                            telefono: null,
                            contrasena:null ,
                             token: _token!,
                            foto: foto,
                            matricula: matricula
                            ));
                            Navigator.push(context, _transition);
                          },
                          child: TextFormField(
                         enabled: false,
                         controller: _correoController,
                         style: TextStyle(color: blanco),
                         keyboardType: TextInputType.emailAddress,
                         decoration: InputDecoration(
                           disabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: blanco)
                           ),
                           border:UnderlineInputBorder(
                             borderSide:
                                    BorderSide(color: blanco)
                           ),
                           labelStyle: TextStyle(color: blanco),
                           suffixIcon: Icon(Icons.arrow_forward_ios, color: blanco, size: 17,)
                          
                         ),
                         
                       )
                       ),
                        SizedBox(height: 20,),
                      //Campo Télefono
                                    const Text(
                                        "Teléfono",
                                        style: TextStyle(
                                          color: blanco,
                                          fontWeight: FontWeight.bold,
                                        ),
                      
                                      ),
                        GestureDetector(
                          onTap:(){
                            //Navegar a la vista correspondiente pasando la variable a editar en este caso el teléfono
                            final SizeTransition5 _transition =SizeTransition5(VerificarContrasena(
                            correo: null,
                            telefono: _telefonoController.text,
                            contrasena:null ,
                             token: _token!,
                            foto: foto,
                            matricula: matricula
                            ));
                            Navigator.push(context, _transition);
                          } ,
                          child: TextFormField(
                         enabled: false,
                         controller: _telefonoController,
                         style: TextStyle(color: blanco),
                         keyboardType: TextInputType.phone,
                         decoration: InputDecoration(
                           disabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: blanco)
                           ),
                           border:UnderlineInputBorder(
                             borderSide:
                                    BorderSide(color: blanco)
                           ),
                           labelStyle: TextStyle(color: blanco),
                           suffixIcon: Icon(Icons.arrow_forward_ios, color: blanco, size: 17,)
                          
                         ),
                         
                       ),
                        ),
                        SizedBox(height: 20,),
                      //Campo contraseña
                                    const Text(
                                        "Contraseña",
                                        style: TextStyle(
                                          color: blanco,
                                          fontWeight: FontWeight.bold,
                                        ),
                      
                                      ),
                        GestureDetector(
                          //Navegar a la vista correspondiente pasando la variable a editar en este caso la contraseña
                          onTap: (){
                           final SizeTransition5 _transition =SizeTransition5(VerificarContrasena(
                            correo: null,
                            telefono: null,
                            contrasena:_contrasena.text,
                             token: _token!,
                            foto: foto,
                            matricula: matricula
                            ));
                            Navigator.push(context, _transition);
                          },
                          child: TextFormField(
                         enabled: false,
                         initialValue: '12345678901',
                         obscureText: true,
                         style: TextStyle(color: blanco),
                         decoration: InputDecoration(
                           disabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: blanco)
                           ),
                           border:UnderlineInputBorder(
                             borderSide:
                                    BorderSide(color: blanco)
                           ),
                           labelStyle: TextStyle(color: blanco),
                           suffixIcon: Icon(Icons.arrow_forward_ios, color: blanco, size: 17,)
                          
                         ),
                         
                       ),
                      )           
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            color: blanco,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
               Navigator.pop(context);
            },
          ),
        ),
      ],
    ));
  }
}

