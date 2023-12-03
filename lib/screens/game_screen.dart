import 'package:flutter/material.dart';
import 'package:tictactoe_final/provider/room_data_provider.dart';
import 'package:tictactoe_final/resources/socket_methods.dart';
import 'package:tictactoe_final/views/scoreboard.dart';
import 'package:tictactoe_final/views/tictactoe_board.dart';
import 'package:tictactoe_final/views/waiting_lobby.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int pointsToWin = 2;
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateRoomListener(context);
    _socketMethods.updatePlayersStateListener(context);
    _socketMethods.pointIncreaseListener(context);
    _socketMethods.endGameListener(context);
  }

  @override
  void dispose() {
    _socketMethods.unupdateRoomListener();
    _socketMethods.unupdatePlayersStateListener();
    _socketMethods.unpointIncreaseListener();
    _socketMethods.unendGameListener();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    return Scaffold(
      body: roomDataProvider.roomData['isJoin']
          ? const WaitingLobby()
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Scoreboard(),
                  const TicTacToeBoard(),
                  Text(
                    '${roomDataProvider.roomData['turn']['nickname']}\'s turn',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text("Points to Win: $pointsToWin"),
                ],
              ),
            ),
    );
  }
}
