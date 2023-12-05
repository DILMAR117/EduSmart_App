import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../api/conexion.dart';
import '../../../../constants.dart';
import '../../../../utils/app_text_styles.dart';

class EditCorreo extends StatefulWidget {
  final String correo;
  final String matricula;
  final String token;
  final String foto;
  const EditCorreo({
    Key? key,
    required this.correo,
    required this.matricula,
    required this.token,
    required this.foto,
    
}):super (key: key);

  @override
  State<EditCorreo> createState() => _EditCorreoState();
}

class _EditCorreoState extends State<EditCorreo> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Conexion _conexion = Conexion();
  bool _isLoading = false;
  //bool isAnimating = false;


  @override
  void initState() {
    _emailController.text = widget.correo;
    super.initState();
  }

  void _sendEmail() async {
    //Se envian los datos para poder realizar la consulta
    if (_formKey.currentState!.validate()) {
      //Mostrar un indicador al realizar la consulta
      setState(() {
        _isLoading = true;
      });
      // Enviar el correo electrónico aquí
      await _conexion.editarDatos(widget.matricula,_emailController.text, null, null, context, widget.token );
      //Ocultamos el indicador
      setState(() {
        _isLoading = false;
      });
      // Limpiar los campos después de enviar el correo
      Future.delayed(const Duration(microseconds: 900), () {
        _emailController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: ThemeData(primarySwatch: Color.fromARGB(0, 63, 81, 181)),
        home: Scaffold(
          body: Stack(
            children: [
              _isLoading
                  ? Container(
                      color: azul_oscuro,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.blue,
                            strokeWidth: 4,
                          ), // Indicador de carga
                          const SizedBox(height: 20),
                          Text(
                            'Editando correo...',
                            style: AppTextStyles.bodyLightGrey15,
                          ), // Mensaje de cierre de sesión
                        ],
                      ))
                  :
                  // Contenido principal de la pantalla
                  Container(
                      alignment: Alignment.center,
                      color: azul_oscuro,
                      padding: const EdgeInsets.all(40.0),
                      child: SingleChildScrollView(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child:  Container(
                              width: 80,
                              height: 80,
                              child: const CircleAvatar(
                                backgroundColor: blanco,
                                radius: 10.0,
                                child: Icon(Icons.mail_outline,
                                            size: 40.0,
                                            color:azul_oscuro,
                                            ),
                              )
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Ya puedes actualizar tu correo electrónico",
                                  style: TextStyle(
                                    color: blanco,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16.0),
                                //Campo email
                                const Text(
                                  "Correo electrónico",
                                  style: TextStyle(
                                    color: blanco,
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 16),
                                  child: TextFormField(
                                    controller: _emailController,
                                    cursorColor: blanco,
                                    style: const TextStyle(color: blanco),
                                    keyboardType: TextInputType.emailAddress,
                                    
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Por favor, ingrese un correo electrónico.";
                                      }
                                      final emailRex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          caseSensitive: false,
                                          multiLine: false);
                                      if (!emailRex.hasMatch(value)) {
                                        return 'Por favor, ingrese un correo electrónico válido';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blanco)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blanco)),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: SvgPicture.asset(
                                            "assets/icons/correo.svg"),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 0.0),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12, bottom: 0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _sendEmail();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: blanco,
                                      minimumSize:
                                          const Size(double.infinity, 56),
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
                                      "Actualizar correo",
                                      style: TextStyle(
                                          color: azul, fontFamily: "Poppins"),
                                     ),
                                    ),
                                  ),
                                ],
                              ),
                           ),
                          ],
                        )
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
        ));
  }
}
