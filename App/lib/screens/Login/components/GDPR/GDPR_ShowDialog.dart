import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Quizz/widgets/nextbutton/next_button_widget.dart';
String politicas = '''
**Política de Privacidad para EduSmart**

Fecha de la última actualización: 22/11/2023

Bienvenido a EduSmart, estamos comprometidos a proteger la privacidad de nuestros usuarios. Esta Política de Privacidad explica cómo recopilamos, utilizamos, divulgamos y protegemos la información personal de los usuarios.

**1. Información que Recopilamos:**

Datos de Registro: Recopilamos información de registro cuando los docentes crean una cuenta, en donde se incluye sus datos personales.

**2. Uso de la Información:**

Utilizamos la información recopilada para personalizar la experiencia de aprendizaje, mejorar la aplicación, y proporcionar soporte al usuario. No compartimos información personal con terceros sin el consentimiento del usuario, excepto cuando sea necesario para el funcionamiento de la aplicación o cuando lo exija la ley.

**3. Seguridad de los Datos:**

Implementamos medidas de seguridad para proteger la información del usuario contra accesos no autorizados o divulgación. La información del usuario se almacena de manera segura y solo se accede a ella mediante credenciales autorizadas.

**4. Derechos del Usuario:**

Los usuarios tienen el derecho de acceder o corregir su información personal. Para ejercer estos derechos, pueden ponerse en contacto con nosotros a través de edusmartcodetech@gmail.com.

**5. Cambios en la Política de Privacidad:**

Nos reservamos el derecho de modificar esta Política de Privacidad en cualquier momento. Los cambios se notificarán a los usuarios a través de la aplicación o por otros medios.

**6. Información de Contacto:**

Para preguntas o inquietudes relacionadas con la privacidad, los usuarios pueden ponerse en contacto con nosotros a través de edusmartcodetech@gmail.com.

**Términos y Condiciones de Uso**

Estos Términos y Condiciones de Uso rigen el uso de la aplicación móvil EduSmart desarrollada por CodeTech. Al acceder y utilizar la App, aceptas estar legalmente vinculado por estos Términos.

**Licencia de Uso**

**1. Concesión de Licencia:** Se otorga una licencia limitada, no exclusiva, intransferible y revocable para descargar, instalar y utilizar la App con el propósito exclusivo de acceso a los servicios educativos proporcionados por la App.

**2. Restricciones de Uso:** 

  **No puedes:**
  a. Copiar, modificar, o distribuir la App.
  b. Intentar eludir cualquier medida de seguridad de la App.
  c. Utilizar la App de manera que viole leyes aplicables o derechos de terceros.

**Contenido Educativo**

**1. Propiedad del Contenido:** Todo el contenido educativo proporcionado a través de la App es propiedad intelectual de la Institución, Docente o sus licenciantes y está protegido por leyes de propiedad intelectual.

**2. Uso del Contenido:** Puedes utilizar el contenido educativo de la App para fines personales y educativos. Queda prohibida la reproducción o distribución no autorizada del contenido.

**Privacidad**

**1. Datos del Usuario:** Al utilizar la App, aceptas nuestra Política de Privacidad antes mencionada, que describe cómo recopilamos, utilizamos y compartimos tus datos.

**Modificaciones y Terminación**

**1. Modificaciones:** Nos reservamos el derecho de modificar estos Términos en cualquier momento. Las modificaciones entrarán en vigencia después de su publicación en la App.

**2. Terminación:** Podemos terminar tu acceso a la App si violas estos Términos.

**Ley Aplicable**

Estos Términos se regirán e interpretarán de acuerdo con las leyes del País sin tener en cuenta sus principios de conflicto de leyes.

Gracias por confiar en EduSmart para su aprendizaje. ¡Nos esforzamos por proporcionar una experiencia educativa segura y enriquecedora!


 ''';
void showGDPRDialog(BuildContext context,{required ValueChanged<bool> onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible:false,//Evita que se cierre al tocar fuera del dialogo
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return  StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return WillPopScope(
          onWillPop: () async {
            //Evita que se cierre al presionar el botón de retroceso del dispositivo
            return false;
          },
        child: Center(
        child: Container(
          //Tamaño del showdialog
          height: 600,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
           //Formulario
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body:  Stack(
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
                  child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    const Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/icono.png'),
                        radius: 30
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "EduSmart solicita tu consentimiento para usar tus datos personales con estos objetivos:",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      
                    ),
                    const SizedBox(height: 5),
                    buildRichText(politicas, context)
                  ],
                ),
                ),
              ],
            ),
            //Botónes para aceptar las politicas de privacidad
            bottomNavigationBar: SafeArea(
              minimum: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: NextButtonWidget.blue(
                            label: 'No Consentir',
                            onTap: (){
                              setState((){
                                //Se cierra el dialogo antes de cerrar la aplicación
                                Navigator.of(context).pop();
                                setState((){
                                  //Se cierra la aplicación cuando no acepta la politica
                                  SystemNavigator.pop();
                                });
                                
                              });
                            }
                          ),
                        ),
                      const SizedBox(width: 7),
                      Expanded(
                          child: NextButtonWidget.blue(
                            label: 'Consentir',
                            onTap: (){
                              setState((){
                                //Le pasamos el valor que indica que las politicas de privacidad fueron aceptadas, para ya no volver a mostrar la politica
                                 onValue(false);
                                 Navigator.of(context).pop();
                              });
                            }
                          ),
                        ),
                    ],
                  ),
                )
              ),
          ),
        ),
      
      )
      );
      }
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      // if (anim.status == AnimationStatus.reverse) {
      //   tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      // } else {
      //   tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      // }

      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        // child: FadeTransition(
        //   opacity: anim,
        //   child: child,
        // ),
        child: child,
      );
    },
    
  );
}


 Widget buildRichText(String text, BuildContext context) {
    List<TextSpan> textSpans = [];

    RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int currentIndex = 0;

    for (RegExpMatch match in matches) {
      if (match.start > currentIndex) {
        textSpans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
          ),
        );
      }

      textSpans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(currentIndex),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'popins', color: Colors.black),
        children: textSpans,
      ),
    );
  }
  



