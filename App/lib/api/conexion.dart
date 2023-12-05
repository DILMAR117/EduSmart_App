// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/Login/components/resetpassword/nueva_contrasena.dart';
import '../screens/Login/components/resetpassword/verificar_clave.dart';
import '../utils/transition.dart';
import 'message.dart';


class Conexion with ChangeNotifier {
  List<dynamic> materias =[];
  List<dynamic> unidades=[];
  List<dynamic> temas=[];
  List<dynamic> subtemas=[];
  List<dynamic> infografias=[];
  List<dynamic> videos=[];
  List<dynamic> preguntas=[];
  List<dynamic> respuestas= [];
  List<dynamic> ranking =[];
  Map<String, dynamic>? userData;
  String? matricula;
  String? token;
  int? intentos;
  List<dynamic> activo = [];
  List<dynamic> idExamen =[];
  int? _id;
  //String ip ="https://edusmartapi-dev-mftg.3.us-1.fl0.io"; 
  String ip ="http://192.168.1.90:3000";
  String urlImg ="http://192.168.1.90/EduSmart_Equipos/multimedia/";
  //String urlImg="https://codeedusmart.com/files/public_html/files/materias/";
  //String urlDoc ="https://codeedusmart.com/files/public_html/files/uploads";
  String urlDoc ="http://192.168.1.90/EduSmart_Equipos//uploads";
  final Message _meessage =Message();
//Método para poder extraer a los alumnos autenticados
  Future<void> _getUserData(String matricula, String token) async {
    final String url = '$ip/user/$matricula';
    try {
      final response = await http.get(Uri.parse(url),
        headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
      );

      if (response.statusCode == 200) {
        
          userData = jsonDecode(response.body);
          _id=userData!["id_alumno"];
         //Le pasamos el id del alumno autenticado para poder cargar las materias
          fetchMaterias(_id!, token);
        
      } else if (response.statusCode == 404) {
        // Usuario no encontrado.
        //print('Usuario no encontrado');
      } else {
        // Error en el servidor.
        //print('Error interno del servidor');
      }
    } catch (e) {
      // Error de conexión.
      //print('Error de conexión: $e');
    }
  }
  //Método para poder extraer las materias a las que se encuetra inscrito el alumno
Future<void> fetchMaterias(int id, String token) async {
    final response = await http.get(Uri.parse('$ip/api/materias/$id'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        materias = data;
    } else {
      print('Error al obtener las materias');
    }
  }

  //Método para poder extraer todas las unidades por materia
Future<void> fetchUnidades(int id_materia, String token) async {
    final response = await http.get(Uri.parse('$ip/api/unidades/$id_materia'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        unidades = data;
    } else {
      //print('Error al obtener las unidades');
    }
  }
    //Método para poder extraer todos los  temas por unidad
Future<void> fetchTemas(int idUnidad, String token) async {
    final response = await http.get(Uri.parse('$ip/api/temas/$idUnidad'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        temas = data;
    } else {
      //print('Error al obtener los temas');
    }
  }
      //Método para poder extraer todos los  subtemas por tema
Future<void> fetchSubtemas(int idTema, String token) async {
    final response = await http.get(Uri.parse('$ip/api/subtema/$idTema'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        subtemas = data;
    } else {
      //print('Error al obtener los subtemas');
    }
  }
//Método para poder extraer todos las infografías por subtema
Future<void> fetchInfografia(int idSubtema, String token) async {
    final response = await http.get(Uri.parse('$ip/api/infografia/$idSubtema'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        infografias = data;
    } else {
      //print('Error al obtener las infografías');
    }
  }
  //Método para poder extraer todos los videos por subtema
Future<void> fetchVideo(int idSubtema, String token) async {
    final response = await http.get(Uri.parse('$ip/api/video/$idSubtema'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        videos = data;
    } else {
      print('Error al obtener los videos');
    }
  }
  //Método para verificar los examenes activos
  Future<void> fetchExamenActivo(int idMateria, String token) async{
    final response = await http.get(Uri.parse('$ip/api/examenActivo?idMateria=$idMateria'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      activo = data;
    }else{
      print('Error al obtener la consulta');
    }

  }
  //Método para poder consultar las preguntas por materia
Future<void> fetchPregunta(int idAlumno, int idMateria, String token) async {
    final response = await http.get(Uri.parse('$ip/api/preguntas?id_alumno=$idAlumno&id_materia=$idMateria'),
        headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },   
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        preguntas = data;
    } else {
      print('${response.body}');
    }
  }
  //Función para poder almacenar la respuesta de los alumnos
Future<void> guardarRespuestas(
  int idPregunta,
  int idAlumno,
  int idEquipo,
  String respuestas,
  BuildContext context,
  String token,
) async{
  final String serverUrl ='$ip/api/enviar_respuestas';

  try{
    final response = await http.post(
      Uri.parse(serverUrl),
      body: jsonEncode({
        'id_pregunta':idPregunta,
        'id_alumno': idAlumno,
        'id_equipo': idEquipo,
        'respuestas': respuestas

      }),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
    );
    if(response.statusCode == 200){
      
    } else{
      _meessage.mostrarBottomSheet(context,
       'Error',
       'No fue posible guardar las respuestas',
       Colors.red 
       );
    }
  }catch(e){
    _meessage.mostrarBottomSheet(context,
        "Error",
        "Ocurrio un error: $e",
         Colors.red
        );
  }

}
//Función para obtenre las respuestas del alumno y las respeutas de las preguntas
Future<void> fetchRespuestas(int idAlumno, int idMateria, BuildContext context, String token) async{
    final response = await http.get(Uri.parse('$ip/api/respuestas?alumnoId=$idAlumno&materiaId=$idMateria'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },   
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        respuestas = data;
    } else {
      print('Error al obtener las respusetas');
    }
  
}
//Función para almacenar la gamificación
Future<void> enviarGamificacion(
  int idExamen,
  int idAlumno,
  int idMateria,
  double puntaje,
  String token,
)async{
    final String serverUrl ='$ip/api/enviar_gamificacion';
    try{
      final response = await http.post(Uri.parse(serverUrl),
      body: jsonEncode({
        'id_examen':idExamen,
        'id_alumno': idAlumno,
        'id_materia': idMateria,
        'puntajes': puntaje
      }),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
      
      );
      if(response.statusCode == 200){
        print('Se insertaron los daros de manera correcta');

      }else{
        print('No se inserttaron los datod de gamificación');
      }


    }catch(e){
      print('Error de inserción: $e');

    }
  
}
//Función para obtener el id del exámen en la tabla de gamificación  por materia y alumnos inscritos en esa materia
Future<dynamic> fetchIdExamen(int idMateria, int idAlumno, String token)async{
  final response = await http.get(Uri.parse('$ip/api/idexamen?idMateria=$idMateria&idAlumno=$idAlumno'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
  );
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      idExamen = data;
      //print('IdExamen es:$idExamen');
    }else{
      //print("Error al obter el id de exámen");
    }
}
//Función para obtener los datos de gamificación
Future<dynamic> fetchGamificacion(int idMateria, int idExamen, String token) async{
   final response = await http.get(Uri.parse('$ip/api/gamificacion?idMateria=$idMateria&idExamen=$idExamen'),
      headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
   );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        ranking = data;
    } else {
      //print('Error al obtener los datos de gamificación');
    }
    return ranking;

}
// Función para enviar la solicitud PUT al servidor para actualizar los datos del alumno.
Future<void> actualizarDatosAlumno(
  String nombre,
  String app,
  String apm,
  int id,
  BuildContext context,
  String token,
) async {
  final String serverUrl = '$ip/edit/';
  final String url = '$serverUrl$id';
      try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode({
          'nombre': nombre,
          'app': app,
          'apm': apm,
        }),
        headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
      );
      if (response.statusCode == 200) {
         notificarOyentes();
         Navigator.of(context).pop();
           _meessage.mostrarBottomSheet(context,
        "Success",
        "Datos del alumno actualizados correctamente",
         Colors.green
         );
      } else {
        _meessage.mostrarBottomSheet(context,
        "Error", "Error al actualizar datos del alumno",
        Colors.red
        );
      }
      } catch (e) {
        _meessage.mostrarBottomSheet(context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
      }
  }
  // Función para enviar la solicitud PUT al servidor para actualizar los datos del alumno.
Future<void> actualizarCorreoAlumno(
  String correo,
  int id,
  BuildContext context,
  String token,
) async {
  final String serverUrl = '$ip/editcorreo/';
  final String url = '$serverUrl$id';
      try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode({
          'correo': correo,
        }),
        headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
      );
      if (response.statusCode == 200) {
         notificarOyentes();
         Navigator.of(context).pop();
           _meessage.mostrarBottomSheet(context,
        "Success",
        "Correo actualizado correctamente",
         Colors.green
         );
      } else {
        _meessage.mostrarBottomSheet(context,
        "Error", "Error al actualizar correo del alumno",
        Colors.red
        );
      }
      } catch (e) {
        _meessage.mostrarBottomSheet(context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
      }
  }
  Future uploadImage(File image, String matricula, String token) async {
    if (image == null) return;

    String apiUrl = '$ip/actualizar-foto';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['matricula'] =matricula;
    request.files.add(await http.MultipartFile.fromPath('foto', image.path));
    request.headers['Authorization']= token;

    var response = await request.send();

    if (response.statusCode == 200) {
       notificarOyentes();
    } else {
  
    }
  }
  //Función para enviar la el correo con la clave de verificación
  Future<void> resetPassword(BuildContext context, String correo) async{
    String serverUrl ='$ip/recuperar-contrasena';

    try{
      final response = await http.post(Uri.parse(serverUrl),
        body: jsonEncode({
          'correo':correo
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        //Obtenemos el token en la respuesta de la solicitud
           final Map<String, dynamic> data = json.decode(response.body);
           final String token = data['token'];
        final SizeTransition5 _transition = SizeTransition5( VerificarClave(correo: correo, token: token));
        Navigator.push(context, _transition);
        Future.delayed(const Duration(seconds: 2),(){
          _meessage.mostrarBottomSheet(context,
         'Success',
         'Código de verificación enviado con éxito a $correo',
          Colors.green
          );
        
        });
      }else if(response.statusCode == 400){
       _meessage.mostrarBottomSheet(context,
        'Error',
       'El correo $correo no esta registrado',
       Colors.red); 
      }else{
         _meessage.mostrarBottomSheet(context,
        'Error',
       'Error al enviar el correo de recuperación de contraseña',
       Colors.red);
      }

    }catch(e){
      _meessage.mostrarBottomSheet(context,
        'Error',
       'Ocurrio un error ${e}',
       Colors.red); 
    }

  }
  //Función para recuperar la contraseña
  Future<void> verificarClave(BuildContext context, String correo, String clave, String token) async{
    String serverUrl ='$ip/verificar-clave-recuperacion';
    try{
      final response = await http.post(Uri.parse(serverUrl),
        body: jsonEncode({
          'correo':correo,
          'claveUsuario':clave
        }),
        headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
      );
      if(response.statusCode == 200){
        Navigator.popUntil(context, ModalRoute.withName('/'));
        final SizeTransition5 _transition = SizeTransition5( NuevaContrasena(correo: correo, token: token));
        Navigator.push(context, _transition);

      }else if(response.statusCode == 400){
       _meessage.mostrarBottomSheet(context,
        'Error',
       'Clave no válida o tiempo de expiración ha concluido ',
       Colors.red); 
      }else{
         
      }

    }catch(e){
      _meessage.mostrarBottomSheet(context,
        'Error',
       'Ocurrio un error ${e}',
       Colors.red); 
    }

  }
  //Función para poder restablcer la contraseña en la base de datos
    Future<void> restabelcerContrasena(BuildContext context, String contrasena, String correo, String token)async{
      String serverUrl ='$ip/actualizar-contrasena?correo=$correo';
      try {
      final response = await http.put(
        Uri.parse(serverUrl),
        body: jsonEncode({
          'nuevaContrasena': contrasena,
          }),
        headers: <String, String>{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'$token',
        },
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
          _meessage.mostrarBottomSheet(context,
           "Success",
          "La contraseña se reesablecio de manera exitosa",
           Colors.green
         );
       
      } else {
        _meessage.mostrarBottomSheet(context,
        "Error", "No se pudo restablcer la contraseña",
        Colors.red
        );
      }
      } catch (e) {
        _meessage.mostrarBottomSheet(context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
      }

    }
//Función para realizar la verificación de contraseña antes de editar daros como, correo, télefono y contraseña
  Future<void> verificarContrasena(
  String matricula,
  String contrasena,
  BuildContext context,
  Widget page,
  String token
  )async{
    String url = '${ip}/verificarContrasena';
    try{
      final response = await http.post(
              Uri.parse(url),
              body: jsonEncode({
                'matricula': matricula,
                'contrasena': contrasena,
              }),
              headers: <String, String>{
              'Content-Type':'application/json; charset=UTF-8',
              'Authorization':'$token',
              },
            );
            if(response.statusCode ==200){
              Navigator.pop(context);
              final SizeTransition5 _transition = SizeTransition5(page);
              Navigator.push(context, _transition);

            }else {
            _meessage.mostrarBottomSheet(context,
            "Error", "Contraseña Incorrecta",
            Colors.red
            );
          }

    }catch(e){
      _meessage.mostrarBottomSheet(context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
    }

  }
  //Función realizar la edicion de contraseña antes de editar daros como, correo, télefono y contraseña
  Future<void> editarDatos(String matricula,
   String? correo,
   String? telefono,
   String? contrasena,
  BuildContext context,
  String token
  )async{
    String url = '${ip}/editarDatos/$matricula';
    String mensaje = "";
    if(correo != null){
      mensaje ="El correo se actualizo de manera éxitosa";
    }
    if(telefono != null){
      mensaje ="El número de teléfono se actualizo de manera éxitosa";
    }
    if(contrasena != null){
        mensaje= "La contraseña se actualizo de manera éxitosa";
    }
    try{
      final response = await http.put(
              Uri.parse(url),
              body: jsonEncode({
                'correo': correo,
                'telefono': telefono,
                'contrasena': contrasena,
                
              }),
              headers: <String, String>{
              'Content-Type':'application/json; charset=UTF-8',
              'Authorization':'$token',
              },
            );
            if(response.statusCode ==200){
              Navigator.pop(context);
              _meessage.mostrarBottomSheet(context,
              "Success",
              "$mensaje",
              Colors.green
              );
              
            }else {
            _meessage.mostrarBottomSheet(context,
            "Error", "Nose pudo actulizar tu información",
            Colors.red
            );
          }

    }catch(e){
      _meessage.mostrarBottomSheet(context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
    }

  }

//Funciones que tienen que ver con Shared-Preferences

   //Función para guardar los datos del usuario en SharedPreferences.
    Future<void> saveUserData(String matricula,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('matricula', matricula);
     notificarOyentes();
    //print('Matricula guardada $matricula');
  }

//Función para mostrar los datos del usuario con SharedPreferences
  Future<String?>getalumnoData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    matricula =prefs.getString('matricula');
    _getUserData("$matricula", "$token");
     notificarOyentes();
    return matricula;
  }

  //Función para almacenar el token proporcionado
    Future<void>saveToken(String token)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      notificarOyentes();
    }

  //Función para recuperar el token con sharedPreferences
    // Future<String?>getToken() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   token = prefs.getString('token');
    //   return token;
    // }
   //Función para guardar los intentos de inicio de sesión.
    Future<void> saveLoginIntentos(int intentos,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intentos', intentos);
     notificarOyentes();
    print('intento guardado $intentos');
  }
  //Función para mostrar el número de intentos almacenados
  Future<int?>getLoginIntentos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      intentos =prefs.getInt('intentos') ?? 0;
      print('Intentos = $intentos');
     notificarOyentes();
    return intentos;
  }
   //Función para eliminar el número de intentos almacenados
  Future<int?>deleteLoginIntentos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('intentos');
      print('se elimino');
     notificarOyentes();
  }

  //Función para almacenar el resultado de aceptar las politicas de privacidad
    Future<void>savePoliticaAceptada(bool consentimiento)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('consentimiento', consentimiento);
      notificarOyentes();
    }
  void notificarOyentes(){
    notifyListeners();
  }


}
