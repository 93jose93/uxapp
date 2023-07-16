import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:uxapp/components/info_card.dart';
import 'package:uxapp/components/side_menu_title.dart';
import 'package:uxapp/models/rive_asset.dart';
import 'package:uxapp/utils/rive_utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveAsset selectedMenu = sideMenus.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: 288,
          height: double.infinity,
          color: const Color(0xFF17203A),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoCard(
                  name: "Jose Sanchez",
                  profession: "Yotuber",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Navegador".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sideMenus.map(
                  (menu) => SideMenuTile(
                    menu: menu,
                    riveonInt: (artboard) {
                      //  hacer que al dar click la animacion ejecute
                      StateMachineController controller =
                          RiveUtils.getRiverController(artboard,
                              stateMachineName: menu.stateMachineName);
          
                      menu.input = controller.findSMI("active") as SMIBool;
          
                      // print(menu.stateMachineName);
                    },
                    press: () {
                      menu.input!.change(true);
                      Future.delayed(const Duration(seconds: 1), () {
                        menu.input!.change(false);
                      });
          
                      setState(() {
                        selectedMenu = menu;
          
                      });
                    },
                    isActive: selectedMenu == menu,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Historia".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sideMenu2.map(
                  (menu) => SideMenuTile(
                    menu: menu,
                    riveonInt: (artboard) {
                      //  hacer que al dar click la animacion ejecute
                      StateMachineController controller =
                          RiveUtils.getRiverController(artboard,
                              stateMachineName: menu.stateMachineName);
          
                      menu.input = controller.findSMI("active") as SMIBool;
          
                      // print(menu.stateMachineName);
                    },
                    press: () {
                      menu.input!.change(true);
                      Future.delayed(const Duration(seconds: 1), () {
                        menu.input!.change(false);
                      });
          
                      setState(() {
                        selectedMenu = menu;
          
                      });
                    },
                    isActive: selectedMenu == menu,
                  ),
                ),
              ],
            ),
          ),
        )
     );
  }
}
