import 'package:flutter/material.dart';

import 'package:tictactoe_final/provider/room_data_provider.dart';
import 'package:tictactoe_final/resources/game_methods.dart';
import 'package:tictactoe_final/resources/socket_client.dart';
import 'package:tictactoe_final/screens/game_screen.dart';
import 'package:tictactoe_final/screens/main_menu_screen.dart';
import 'package:tictactoe_final/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:flutter/scheduler.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketClient.emit('joinRoom', {
        'nickname': nickname,
        'roomId': roomId,
      });
    }
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  // LISTENERS
  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on('joinRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccuredListener(BuildContext context) {
    _socketClient.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListener(BuildContext context) {
    _socketClient.on('updatePlayers', (playerData) {
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }

  void updateRoomListener(BuildContext context) {
    _socketClient.on('updateRoom', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void tappedListener(BuildContext context) {
    _socketClient.on('tapped', (data) {
      RoomDataProvider roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      roomDataProvider.updateDisplayElements(
        data['index'],
        data['choice'],
      );
      roomDataProvider.updateRoomData(data['room']);
      // check winnner
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    _socketClient.on('pointIncrease', (playerData) {
      var roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.on('endGame', (playerData) {
      //showGameDialog(context, '${playerData['nickname']} won the game!');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext buildContext) {
              Future.delayed(const Duration(seconds: 2), () {
                GameMethods().clearBoard(context);
                Navigator.of(buildContext).pop();
                Navigator.popUntil(
                    context, ModalRoute.withName(MainMenuScreen.routeName));
              });
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: AlertDialog(
                  backgroundColor:
                      Theme.of(context).copyWith().scaffoldBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  title: const Text(
                    "Game Ended",
                  ),
                  content: const Text("You will be returned to homescreen"),
                ),
              );
            },
          );
        });
      });
    });
  }

  //listener removers

  void unCreateRoomSuccessListener() {
    _socketClient.off('createRoomSuccess');
  }

  void unjoinRoomSuccessListener() {
    _socketClient.off('joinRoomSuccess');
  }

  void unerrorOccuredListener() {
    _socketClient.off('errorOccurred');
  }

  void unupdatePlayersStateListener() {
    _socketClient.off('updatePlayers');
  }

  void unupdateRoomListener() {
    _socketClient.off('updateRoom');
  }

  void untappedListener() {
    _socketClient.off('tapped');
  }

  void unpointIncreaseListener() {
    _socketClient.off('pointIncrease');
  }

  void unendGameListener() {
    _socketClient.off('endGame');
  }
}
