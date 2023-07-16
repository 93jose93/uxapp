import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:uxapp/components/animated_bar.dart';
import 'package:uxapp/components/side_menu.dart';
import 'package:uxapp/models/menu_btn.dart';
import 'package:uxapp/models/rive_asset.dart';
import 'package:uxapp/screens/home/home_screen.dart';
import 'package:uxapp/utils/rive_utils.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

//se agrego SingleTickerProviderStateMixin para dar la animacion del menu y home screen

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  //para saber cuando selecciona un boton del menu y su animacion
  RiveAsset selectedButtomNav = bottomNavs.first;

  late AnimationController _animationController;
  late Animation<double> animation;

  late Animation<double> scaleAnimation;

  late SMIBool isSideBarClosed;

  bool isSideMenuClosed = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          //agregar el menu
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: const SideMenu(),
          ),
          //Pagina principal
          //traformar en 3d el card
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              //antes se trabajo asi para darle el efecto
              //isSideMenuClosed ? 0 : 288, 0
              //pero se modifico con Double para darle la animacion
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                //antes se hacia asi
                //isSideMenuClosed ? 1 : 0.8
                //pero se modifico para hacerlo escalar por doble
                scale: scaleAnimation.value,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: HomeScreen(),
                ),
              ),
            ),
          ),

          //menu de opciones superior
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 220,
            top: 16,
            child: MenuBtn(
              riveOnInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiverController(
                    artboard,
                    stateMachineName: "State Machine");
                isSideBarClosed = controller.findSMI("isOpen") as SMIBool;
                isSideBarClosed.value = true;
              },
              press: () {
                isSideBarClosed.value = !isSideBarClosed.value;
          
                //se ejecuta la animacion
                if (isSideMenuClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
          
                setState(() {
                  isSideMenuClosed = isSideBarClosed.value;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(85, 85, 85, 0.945),
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavs.length,
                  (index) => GestureDetector(
                    onTap: () {
                      //selecionar el boton inicio de animacion
                      bottomNavs[index].input!.change(true);
      
                      //detecta el boton para darle el estado y
                      //darle la Opacidada los que sea diferente del activo
                      if (bottomNavs[index] != selectedButtomNav) {
                        setState(() {
                          selectedButtomNav = bottomNavs[index];
                        });
                      }
                      Future.delayed(const Duration(seconds: 1), () {
                        //despues de un segundo ya no anima
                        bottomNavs[index].input!.change(false);
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //animacion que estan encima de los iconos del menu
                        AnimatedBar(
                            isActive: bottomNavs[index] == selectedButtomNav),
                        //aqui esta la lista de iconos con sus animaciones
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity:
                                bottomNavs[index] == selectedButtomNav ? 1 : 0.5,
                            child: RiveAnimation.asset(
                              bottomNavs.first.src,
                              artboard: bottomNavs[index].artboard,
                              onInit: (artboard) {
                                StateMachineController controller =
                                    RiveUtils.getRiverController(artboard,
                                        stateMachineName:
                                            bottomNavs[index].stateMachineName);
      
                                bottomNavs[index].input =
                                    controller.findSMI("active") as SMIBool;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
