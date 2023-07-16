import 'package:rive/rive.dart';

//esto es una class que se repite en formulario login y se usara en menu bar para las animaciones


class RiveUtils {


  static StateMachineController getRiverController(Artboard artboard, {stateMachineName = "State Machine 1"}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);

    return controller;
  }
}