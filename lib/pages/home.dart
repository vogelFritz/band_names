import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Band Names', style: TextStyle(color: Colors.black87))),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
          elevation: 1, onPressed: addNewBand, child: const Icon(Icons.add)),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        // TODO: borrar en el servidor
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
          onTap: () {}),
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
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
