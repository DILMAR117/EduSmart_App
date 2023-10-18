import 'package:edusmart/screens/Menu/unidades_menu.dart';
import 'package:edusmart/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../../api/conexion.dart';

class MateriaScreen extends StatefulWidget {
  const MateriaScreen({Key? key}) : super(key: key);
  @override
  State<MateriaScreen> createState() => _MateriaScreenState();
  }

  class _MateriaScreenState extends State<MateriaScreen>{
    bool isLoading= true;
    final Conexion _conexion = Conexion();
     @override
    void initState() {
      super.initState();
      _conexion.getalumnoData();
        // _conexion.fetchMaterias();
      Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isLoading = false; 
            }
          );
        }
      );
    }

    Future<void> refresh() async {
        await Future.delayed(const Duration(seconds: 4), (){
          setState(() {
           _conexion.getalumnoData();   
          }
        ); 
       }
     );
    }
    
  @override
  Widget build(BuildContext context) {
    //Se muestran los  temas del curso
  return RefreshIndicator(
    onRefresh: refresh,
    child: SingleChildScrollView(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 10),
        Visibility(
          visible: !isLoading,
          child: GridView.builder(
            itemCount: _conexion.materias.length == 0 ? 1 : _conexion.materias.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 16 / 7, crossAxisCount: 1, mainAxisSpacing: 20),
            itemBuilder: (context, index) {
              if (index >= _conexion.materias.length) {
                // Evita que se muestre un elemento nulo
              return  Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 16),
                    ),
                    Container(
                      width: 400,
                      height: 400,
                      child: const RiveAnimation.asset(
                        "assets/RiveAssets/no-results.riv",
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ]
                ); 
              }
              //Se muestra la lista de materias que hay en la base de datos
              final  materia = _conexion.materias[index];
              return GestureDetector( 
                  onTap: () {
                  Navigator.push(
                    context,
                    ScaleTransition5(
                      UnidadesMenu(titulo: materia["nombre_materia"],
                      id_materia: materia["id_materia"],
                      )
                    )
                    /*MaterialPageRoute(
                      builder: (context) => SubtemaMenu(
                        subtemas: tema[index].subtemas,
                        titulo: materia['nombre_materia'],
                      ),
                    ),*/
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        image: AssetImage("assets/box/${materia['img']}"),
                        fit: BoxFit.fill
                    ),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 1.0,
                    heightFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  materia['nombre_materia'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold
                                    ),
                                ),
                                Text(
                                  "Doncente: ${materia['nombre_docente']} ""${materia['app']} "" ${materia['apm']}",
                                   style: const TextStyle(
                                    color: Colors.white, fontSize: 18
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  )
                ),
              );
            }
          )
        ),
        const SizedBox(height: 130.0),
        Visibility(
          visible: isLoading, // Muestra el loading cuando isLoading es true
          child:const Padding(
              padding: EdgeInsets.symmetric(vertical: 150),
              child: Center(
                child:CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
              ), 
            )
          )
      ],
      ),
    ) 
  );
    
      
    
  }
}
