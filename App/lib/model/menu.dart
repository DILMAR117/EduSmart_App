import 'package:flutter/material.dart';
import '../views/perfil.dart';
import '../views/ranking.dart';
import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;
  final String? ruta;
  final Widget? page;

  Menu({required this.title, 
  required this.rive,
   this.ruta,
   this.page,
  });
}
List<Menu> sidebarMenus = [
  Menu(
    title: "Perfil",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
    page:const  ProfileApp(), 
  ),
  Menu(
    title: "Ranking",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "LIKE/STAR",
        stateMachineName: "STAR_Interactivity"),
    page: Ranking(),
  ),
  Menu(
    title: "Acerca de",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
        ruta: "",
  ),
];
List<Menu>menu2=[
 Menu(
    title: "Cerrar Sesión",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
    ruta: "/"
  ),
];
List<Menu>home=[
   Menu(
    title: "Home",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
        ruta: '/home'
  ),
];


