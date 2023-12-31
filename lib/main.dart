import 'package:flutter/material.dart';

import 'package:tictactoe_final/provider/room_data_provider.dart';
import 'package:tictactoe_final/screens/create_room_screen.dart';
import 'package:tictactoe_final/screens/game_screen.dart';
import 'package:tictactoe_final/screens/join_room_screen.dart';
import 'package:tictactoe_final/screens/main_menu_screen.dart';
import 'package:tictactoe_final/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoomDataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
        ),
        routes: {
          MainMenuScreen.routeName: (context) => const MainMenuScreen(),
          JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
          CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
          GameScreen.routeName: (context) => const GameScreen(),
        },
        initialRoute: MainMenuScreen.routeName,
      ),
    );
  }
}
