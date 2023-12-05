import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../api/conexion.dart';
import '../../../../constants.dart';
import '../../../../utils/app_text_styles.dart';

class EditTelefono extends StatefulWidget {
  final String telefono;
  final String matricula;
  final String token;
  final String foto;
  const EditTelefono({
    Key? key,
    required this.telefono,
    required this.matricula,
    required this.token,
    required this.foto,
    
}):super (key: key);

  @override
  State<EditTelefono> createState() => _EditTelefonoState();
}

class _EditTelefonoState extends State<EditTelefono> {
  final TextEditingController _telefonoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Conexion _conexion = Conexion();
  bool _isLoading = false;
  //bool isAnimating = false;


  @override
  void initState() {
    _telefonoController.text = widget.telefono;
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
      await _conexion.editarDatos(widget.matricula, null, _telefonoController.text, null, context, widget.token );
      //Ocultamos el indicador
      setState(() {
        _isLoading = false;
      });
      // Limpiar los campos después de enviar el correo
      Future.delayed(const Duration(microseconds: 900), () {
        _telefonoController.clear();
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
                            'Editando número de teléfono...',
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
                                child: Icon(Icons.phone,
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
                                  "Ya puedes actualizar tu número de teléfono",
                                  style: TextStyle(
                                    color: blanco,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16.0),
                                //Campo teléfono
                                const Text(
                                        "Teléfono",
                                        style: TextStyle(
                                            color: blanco,
                                            fontWeight: FontWeight.bold),
                                      ),
                                     Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                                        child: TextFormField(
                                            cursorColor: blanco,
                                            maxLength: 10,
                                            controller: _telefonoController,
                                            style:
                                                const TextStyle(color: blanco),
                                            keyboardType:
                                                TextInputType.phone,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Por favor, ingrese su número de teléfono.";
                                              }else if (value.length < 10) {
                                                return 'Se requiere al menos 10 dígitos.';
                                              }
                                              return null;
                                            },
                                            decoration: const  InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: blanco)),
                                              focusedBorder:
                                                   UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: blanco)),
                                              counterStyle: TextStyle(
                                                color: blanco
                                              )
                                            ))),
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
                                      "Actualizar teléfono",
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
