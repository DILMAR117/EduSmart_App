import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  int? _id;
  String ip ="192.168.1.90:3000"; 
  final Message _meessage =Message();
//Método para poder extraer a los alumnos autenticados
  Future<void> _getUserData(String matricula) async {
    final String url = 'http://$ip/user/$matricula';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        
          userData = jsonDecode(response.body);
          _id=userData!["id_alumno"];
         //Le pasamos el id del alumno autenticado para poder cargar las materias
          fetchMaterias(_id!);
        
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
Future<void> fetchMaterias(int id) async {
    final response = await http.get(Uri.parse('http://$ip/api/materias/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        materias = data;
    } else {
      print('Error al obtener las materias');
    }
  }

  //Método para poder extraer todas las unidades por materia
Future<void> fetchUnidades(int id_materia) async {
    final response = await http.get(Uri.parse('http://$ip/api/unidades/$id_materia'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        unidades = data;
    } else {
      //print('Error al obtener las unidades');
    }
  }
    //Método para poder extraer todos los  temas por unidad
Future<void> fetchTemas(int id_unidad) async {
    final response = await http.get(Uri.parse('http://$ip/api/temas/$id_unidad'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        temas = data;
    } else {
      //print('Error al obtener los temas');
    }
  }
      //Método para poder extraer todos los  subtemas por tema
Future<void> fetchSubtemas(int id_tema) async {
    final response = await http.get(Uri.parse('http://$ip/api/subtema/$id_tema'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        subtemas = data;
    } else {
      //print('Error al obtener los subtemas');
    }
  }
//Método para poder extraer todos las infografías por subtema
Future<void> fetchInfografia(int id_subtema) async {
    final response = await http.get(Uri.parse('http://$ip/api/infografia/$id_subtema'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        infografias = data;
    } else {
      //print('Error al obtener las infografías');
    }
  }
  //Método para poder extraer todos los videos por subtema
Future<void> fetchVideo(int id_subtema) async {
    final response = await http.get(Uri.parse('http://$ip/api/video/$id_subtema'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        videos = data;
    } else {
      print('Error al obtener los videos');
    }
  }
  //Método para poder extraer todos los videos por subtema
Future<void> fetchPregunta(int id_alumno) async {
    final response = await http.get(Uri.parse('http://$ip/api/preguntas/$id_alumno'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        preguntas = data;
    } else {
      print('Error al obtener las preguntas');
    }
  }
  //Función para poder almacenar la respuesta de los alumnos
Future<void> guardarRespuestas(
  int id_pregunta,
  int id_alumno,
  int id_equipo,
  String respuestas,
  BuildContext context
) async{
  final String serverUrl ='http://$ip/api/enviar_respuestas';

  try{
    final response = await http.post(
      Uri.parse(serverUrl),
      body: jsonEncode({
        'id_pregunta':id_pregunta,
        'id_alumno': id_alumno,
        'id_equipo': id_equipo,
        'respuestas': respuestas

      }),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      
    } else{
      _meessage.mostrarBottomSheet(context, 'Error',
       'No fue posible guardar las respuestas',
       Colors.red 
       );
    }
  }catch(e){
    _meessage.mostrarBottomSheet(
        context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
  }

}
//Función para obtenre las respuestas del alumno y las respeutas de las preguntas
Future<void> fetchRespuestas(int id_alumno, BuildContext context) async{
    final response = await http.get(Uri.parse('http://$ip/api/respuestas/$id_alumno'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        respuestas = data;
    } else {
      print('Error al obtener las respusetas');
    }
  
}
//Función para almacenar la gamificación
Future<void> enviarGamificacion(
  int id_examen,
  int id_alumno,
  int id_materia,
  double puntaje
)async{
    final String serverUrl ='http://$ip/api/enviar_gamificacion';
    try{
      final response = await http.post(Uri.parse(serverUrl),
      body: jsonEncode({
        'id_examen':id_examen,
        'id_alumno': id_alumno,
        'id_materia': id_materia,
        'puntaje': puntaje
      }),
      headers: {'Content-Type': 'application/json'},
      
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
//Función para obtener los datos de gamificación
Future<dynamic> fetchGamificacion() async{
   final response = await http.get(Uri.parse('http://$ip/api/gamificacion'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        ranking = data;
    } else {
      print('Error al obtener los datos de gamificación');
    }
    return ranking;

}
// Función para enviar la solicitud PUT al servidor para actualizar los datos del alumno.
Future<void> actualizarDatosAlumno(
  String telefono,
  String correoElectronico,
  String nombre,
  String app,
  String apm,
  int id,
  BuildContext context
) async {
  final String serverUrl = 'http://$ip/edit/';
  final String url = '$serverUrl$id';
      try {
      final response = await http.put(
        Uri.parse(url),
        body: {
          'telefono': telefono,
          'correo': correoElectronico,
          'nombre': nombre,
          'app': app,
          'apm': apm,
        },
      );
      if (response.statusCode == 200) {
        _meessage.mostrarBottomSheet(context,"Success",
        "Datos del alumno actualizados correctamente",
         Colors.green
         );
         notifyListeners();
        print('Datos del alumno actualizados correctamente');
      } else {
        _meessage.mostrarBottomSheet(context,
        "Error", "Error al actualizar datos del alumno",
        Colors.red);
        print('Error al actualizar datos del alumno');
      }
      } catch (e) {
        _meessage.mostrarBottomSheet(
        context,
        "Error",
        "Error de conexion: $e",
         Colors.red
        );
      print('Error de conexión: $e');
      }
  }
  Future uploadImage(File image, String matricula,) async {
    if (image == null) return;

    String apiUrl = 'http://$ip/actualizar-foto';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['matricula'] =matricula;
    request.files.add(await http.MultipartFile.fromPath('foto', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      /*Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(
                        builder: (context) =>  ProfileApp(),
                      ),
                      (Route<dynamic> route) => false, // Predicado para eliminar todas las rutas anteriores
                    );*/
      print('Foto del alumno actualizada correctamente.');
    } else {
      print('Error al actualizar la foto del alumno.');
    }
  }
  

   //Función para guardar los datos del usuario en SharedPreferences.
    Future<void> saveUserData(String matricula,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('matricula', matricula);
    //print('Matricula guardada $matricula');
  }
//Función para mostrar los datos del usuario con SharedPreferences
  Future<String?>getalumnoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    matricula =prefs.getString('matricula');
    _getUserData("$matricula");
    return matricula;
  }


}
