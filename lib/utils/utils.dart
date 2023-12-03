import 'package:flutter/material.dart';
import 'package:tictactoe_final/resources/game_methods.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

void showGameDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext buildContext) {
      Future.delayed(const Duration(seconds: 1), () {
        GameMethods().clearBoard(context);
        Navigator.of(buildContext).pop(); // close the dialog
      });
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: AlertDialog(
          backgroundColor: Theme.of(context).copyWith().scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          title: Text(
            text,
            style: const TextStyle(shadows: [
              Shadow(blurRadius: 20, color: Colors.blue),
            ]),
          ),
        ),
      );
    },
  );
}

// void showGameDialog(BuildContext context, String text) {
//   showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: Text(text),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 GameMethods().clearBoard(context);
//                 Navigator.pop(ctx);
//               },
//               child: const Text(
//                 'Play Again',
//               ),
//             ),
//           ],
//         );
//       });
// }
