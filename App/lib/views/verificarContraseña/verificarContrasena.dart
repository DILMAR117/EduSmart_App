import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../api/conexion.dart';
import '../../../../constants.dart';
import '../../../../utils/app_text_styles.dart';
import 'editContrasena.dart';
import 'editCorreo.dart';
import 'editTelefono.dart';


class VerificarContrasena extends StatefulWidget {
 final String? correo;
 final String? telefono;
 final String? contrasena;
 final String token;
 final String foto;
 final String matricula;
   const VerificarContrasena({
        Key? key,
        required this.correo,
        required this.telefono,
        required this.contrasena,
        required this.token,
        required this.foto,
        required this.matricula,
      }): super (key: key);

  @override
  State<VerificarContrasena> createState() => _VerificarContrasenaState();
}

class _VerificarContrasenaState extends State<VerificarContrasena> {
  final TextEditingController _contrasenaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Conexion _conexion =Conexion();
  bool _isLoading = false;
  Widget? pages; 
  //bool isAnimating = false;
  //Funcion que valida los datos ante un caracter malisioso
  bool validarEntrada(String entrada){
    List<String> caracteresMaliciosos =["'", ";", "--", "/* ", "%", "=", "*", "/"];
    return caracteresMaliciosos.any((caracter) => entrada.contains(caracter));
  }

  @override
  void initState() {
    super.initState();
  }
  void _sendClave(String _contrasena) async {
    if (_formKey.currentState!.validate()) {
      //Mostrar un indicador al realizar la consulta
        setState(() {
          _isLoading = true;
          //Indicamos si el valor que recibe no es un correo nulo podra navegar a esta vista
          if(widget.correo != null){
            pages = EditCorreo(correo: widget.correo!,
            matricula: widget.matricula,
            token:widget.token,
            foto: widget.foto,
            );
          }
          //Indicamos si el valor que recibe no es un teléfono nulo podra navegar a esta vista
          if(widget.telefono != null){
            pages = EditTelefono(
              telefono: widget.telefono!,
              matricula: widget.matricula,
              token:widget.token,
              foto:widget.foto,
              );
          }
          //Indicamos si el valor que recibe no es una contraseña nula podra navegar a esta vista
          if(widget.contrasena != null){
            pages = EditContrasena(
              contrasena: widget.contrasena!,
              matricula: widget.matricula,
              token: widget.token,
              foto: widget.foto,
              );

          }
        });
      // Verificar la clave ingresada
      await _conexion.verificarContrasena(
       widget.matricula,
       _contrasena, context,
       pages!,
       widget.token
      );
      //Ocultamos el indicador 
          setState(() {
            _isLoading = false;
          });
      // Limpiar los campos después de enviar la clave
       Future.delayed(
         const Duration(microseconds: 900),
         (){
          _contrasenaController.clear();
         }
       );
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(primarySwatch: Color.fromARGB(0, 63, 81, 181)),
      home: Scaffold(
        body:Stack(
        children: [
           _isLoading ?
          Container(
            color: azul_oscuro,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.blue,
                      strokeWidth: 4,
                    ), // Indicador de carga
                const SizedBox(height: 20),
                Text(
                      'Verificando contraseña...',
                      style: AppTextStyles.bodyLightGrey15,
                  ), // Mensaje de cierre de sesión
                ],
              )
          )
          // Contenido principal de la pantalla
          : Center(
          child:  Center(
          child: Container(
            color: azul_oscuro,
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                    width: 80,
                    height: 80,
                    child: const CircleAvatar(
                      backgroundColor: blanco,
                      radius: 10.0,
                      child: Icon(Icons.lock,
                                  size: 40.0,
                                  color:azul_oscuro,
                                  ),
                    )
                  ),
                
                 const SizedBox(height: 16.0),

                  const Text(
                    "Para poder continuar primero debes verificar tu identidad",
                    style: TextStyle(
                        color: blanco, fontFamily:
                         "Poppins", fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                  ),
                 const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextFormField(
                      obscureText: true,
                      controller: _contrasenaController,
                      cursorColor: blanco,
                      style: const TextStyle(color: blanco),
                      keyboardType: TextInputType.text,
                      maxLength: 18,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Por favor, ingrese la clave.";
                        }if(validarEntrada(value)){
                         return "Algun caracter ingresado es inválido";

                        }
                        return null;
                      },
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: blanco)
                        ),
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: blanco)
                        ),
                        counterStyle: TextStyle(color: blanco),
                        prefixIcon: Icon(Icons.lock_outline, color: blanco),
                        counterText: ''
                      ),
                    ),
                  ),
                  Padding(
                    padding:const EdgeInsets.only(top: 12, bottom: 0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _sendClave(_contrasenaController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blanco,
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: azul,
                      ),
                      label: const Text(
                        "Verificar Contraseña",
                        style: TextStyle(color: azul, fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
          // Botón de regreso
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
           const Positioned(
            top: 55,
            right: 135,
            child: Text(
              "Cuenta de EduSmart",
              style: TextStyle(
                  color: blanco,
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )),
             Positioned(
              top: 40,
              right: 10,
              child:GestureDetector(
                        onTap: (){
                         
                        },
                        child: Container(
                        margin:const EdgeInsets.only(top: 5, right: 16, bottom: 5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              '${_conexion.ip}/get-image/${widget.foto}'),
                        ),
                      ),
                      )
                    )
        ],
      ),
    ) 
    );
  }
}
