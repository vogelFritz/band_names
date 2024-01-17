import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'vienas philarmonic orchestra', votes: 5),
    Band(id: '3', name: 'iwachu', votes: 5),
    Band(id: '4', name: 'Queen', votes: 5),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', (payload) {
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Band Names', style: TextStyle(color: Colors.black87))),
        backgroundColor: Colors.white,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.online
                  ? Icon(Icons.check_circle, color: Colors.blue[300])
                  : const Icon(Icons.offline_bolt, color: Colors.red))
        ],
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
          elevation: 1, onPressed: addNewBand, child: const Icon(Icons.add)),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        socketService.socket.emit('delete-band', {'id': band.id});
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(band.name.substring(0, 2)),
          ),
          title: Text(band.name),
          trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
          onTap: () {
            socketService.socket.emit('vote-band', {'id': band.id});
          }),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text('New Band Name:'),
                content: TextField(
                  controller: textController,
                ),
                actions: <Widget>[
                  MaterialButton(
                    elevation: 5,
                    onPressed: () => addBandToList(textController.text),
                    textColor: Colors.blue,
                    child: const Text('Add'),
                  )
                ]);
          });
      return;
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: const Text('New Band Name:'),
                content: CupertinoTextField(
                  controller: textController,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('Add'),
                    onPressed: () => addBandToList(textController.text),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text('Dismiss'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ]));
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('new-band', {'name': name});
    }
    Navigator.pop(context);
  }
}
