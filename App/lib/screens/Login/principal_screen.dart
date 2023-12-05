import 'dart:async';
import 'dart:ui';
import 'package:edusmart/main.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/conexion.dart';
import '../../api/message.dart';
import '../../utils/app_text_styles.dart';
import 'components/GDPR/GDPR_ShowDialog.dart';
import 'components/btn_animado.dart';
import 'components/sign_in_dialog.dart';

//Pantalla principal de la aplicación
class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;
  final Conexion _conexion = Conexion();
  final Message _message =Message();

  bool isShowSignInDialog = false;
  bool isShowDialogGDPR = false;
  bool _isButtonDisabled = false;
  int _intentos = 0;
  final int _maxIntentos = 3;
  DateTime? tiempoBloqueo;
  Duration _duration = const Duration();
  Timer? _timer;

  @override
  void initState() {
    _obtenerPoliticaAceptada();
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
    _obtenrintentos();
  }
  
    Future<void> _obtenerPoliticaAceptada()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? politicaAceptada = prefs.getBool('consentimiento');

    setState(() {
      //Si las politicas no fueron aceptas entonces mostrar las politicas de privacidad
      if(politicaAceptada == null){
        isShowDialogGDPR = true;
        _mostrarDialog();
      }else if(politicaAceptada == true){
        _mostrarDialog();
      }
    });  
    
  }

  void _mostrarDialog(){
    Future.delayed(
      const Duration(milliseconds: 800),
      () {
        showGDPRDialog(
          context,
          onValue:( value) {
          setState(() {
          isShowDialogGDPR = value;
          //Almacenamos el valor cuando se acepten las politicas de privacidad
          _conexion.savePoliticaAceptada(value);
         });
      
        }    
        );
      },
    );
  }
  _obtenrintentos() async {
    await _conexion.getLoginIntentos();
    setState((){
      _intentos = _conexion.intentos!;
      _bloquear();
    });
    
  }
  //Recibir el número de intentos
  void onSelectIntentos( value) {
       setState(() {
       _isButtonDisabled = true;
       _startTimer();
     });
    }
    void _bloquear(){
      //Metodo para bloquer el bóton el número de intentos en el inicio de sesión
        if(_intentos >= _maxIntentos){
          setState(() {
            //Desabilitamos el bóton
            _isButtonDisabled = true;
            _startTimer();
          });
          
        }
    }
   //Iniciar el cronometro del tiempo de bloque del bóton
   void _startTimer() async{
     tiempoBloqueo = DateTime.now().add(const Duration(minutes: 1));
     //Iniciar un temporizador para actualizar el tiempo restante
    _timer = Timer.periodic(const Duration(hours: 5), (timer) {
      _duration = tiempoBloqueo!.difference(DateTime.now());
      setState(() {
      if(_duration.inSeconds > 0){
        
          _duration -= const Duration(seconds: 1);
          _isButtonDisabled = true;
        
        //Cuando llega a cero se detiene el tiempo habilita el bóton y se reinicia el número de intentos
      }else{
        setState(() {
            _timer?.cancel();
          _isButtonDisabled = false;
        });
        _conexion.deleteLoginIntentos();
       
      }
      });
      
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: isShowSignInDialog ? isShowDialogGDPR? -50 : 0 -50: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 70),
                    ),
                     const Text(
                            "Bienvenido a",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                     const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                        Image.asset(
                        'assets/logo.png',
                        width: 325, 
                        height: 325, 
                        fit: BoxFit.contain, // Ajusta el modo de ajuste de la imagen
                      ),
                   //const Spacer(flex: 1),
                   const SizedBox(height: 70,),
                   _isButtonDisabled == true?
                   Text("Tiempo restante:${_duration.inHours}:${_duration.inMinutes %60}m:${_duration.inSeconds %60}s",
                      style: AppTextStyles.heading15
                    )
                   :
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;

                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              isShowSignInDialog = true;
                            });
                            showCustomDialog(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowSignInDialog = false;
                                });
                              }, intentos: onSelectIntentos
                            );
                          },
                        );
                      },
                    ),
                    /*Padding(
                      padding:const EdgeInsets.symmetric(vertical: 25),
                      child: TextButton(
                                onPressed: () {  
                                },
                                child:const Text('Terminos y condiciones',
                                    style: TextStyle(
                                        color: azul,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline)),
                              ),
                    )*/
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  //Método para eliminar el número de intentos cuando se cierre la app
  @override
  void dispose(){
    _conexion.deleteLoginIntentos();
    super.dispose();
  }
}
void main(){
  runApp(MyApp());
}
