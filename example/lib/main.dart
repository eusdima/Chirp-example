import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:chirpsdk/chirpsdk.dart';
import 'package:simple_permissions/simple_permissions.dart';

/// Enter Chirp application credentials below
String _appKey = '3aA7EceD1a5CBf2aA7a02B304';
String _appSecret = 'EC69fA4bed8E344e1D51380a3fAbCFBF37bf751148e335B4E3';
String _appConfig =
    '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';

void main() => runApp(ChirpApp());

class ChirpApp extends StatefulWidget {
  @override
  _ChirpAppState createState() => _ChirpAppState();
}

class _ChirpAppState extends State<ChirpApp> with WidgetsBindingObserver {
  final chirpYellow = Colors.blue;
  final myController = TextEditingController();

  ChirpState _chirpState = ChirpState.not_created;
  Uint8List _chirpData = Uint8List(0);
  String result = '';

  List<Uint8List> packets = [];

  List<Uint8List> receivingPackets = [];
  bool multiplePackets = false;
  int expectingPackets = 0;

  String parsedData = '';
  bool started = true;

  Future<void> _initChirp() async {
    await ChirpSDK.init(_appKey, _appSecret);
  }

  Future<void> _configureChirp() async {
    await ChirpSDK.setConfig(_appConfig);
  }

  Future<void> _sendRandomChirp() async {
    String text = myController.text;
    sendPackets(text);
    print(text);

    // await ChirpSDK.sendRandom();
    // await ChirpSDK.send(bytes);
  }

  Future<void> _startAudioProcessing() async {
    await ChirpSDK.start();
  }

  Future<void> _stopAudioProcessing() async {
    await ChirpSDK.stop();
  }

  Future<void> _toggleChirp() async {
    if (_chirpState == ChirpState.running) {
      await ChirpSDK.stop();
      this.setState(() => started = true);
    } else {
      await ChirpSDK.start();
      this.setState(() => started = false);
    }
  }

  Future<void> _setChirpCallbacks() async {
    ChirpSDK.onStateChanged.listen((e) {
      setState(() {
        _chirpState = e.current;
      });
    });
    ChirpSDK.onSending.listen((e) {
      setState(() {
        _chirpData = e.payload;
      });
    });
    ChirpSDK.onSent.listen((e) {
      setState(() {
        _chirpData = e.payload;
        print('SENT');
        sendPacketNow();
      });
    });

    ChirpSDK.onReceived.listen((e) {
      setState(() {
        dynamic packet = e.payload;
        print("GOT THIS PACKET");
        print(packet);
        if (expectingPackets == 0) {
          expectingPackets = packet[0];
          receivingPackets.clear();
        }

        expectingPackets -= 1;
        receivingPackets.add(packet);

        if (expectingPackets == 0) {
          assembleReceivedPackets();
        }
      });
    });
  }

  Future<void> _requestPermissions() async {
    bool permission =
        await SimplePermissions.checkPermission(Permission.RecordAudio);
    if (!permission) {
      await SimplePermissions.requestPermission(Permission.RecordAudio);
    }
  }

  Future<void> sendPackets(String message) async {
    try {
      List<int> bytes = utf8.encode(message);
      List<int> toSend = [];
      final int maxSize = 8;

      int packetsToSend = ((bytes.length + 1) / maxSize).ceil();
      int packetIndex = 7;

      // First packet gets the packetSize
      // Add 7 extra bits to the initial packet

      toSend.add(packetsToSend);
      for (int i = 0; i < 7 && i < bytes.length; i++) {
        toSend.add(bytes[i]);
      }

      await addPacketToQueue(toSend);
      sendPacketNow();
      packetsToSend -= 1;
      toSend.clear();

      // Send the rest of packages
      while (packetsToSend > 0) {
        for (int i = packetIndex;
            (i < packetIndex + 8) && i < bytes.length;
            i++) {
          toSend.add(bytes[i]);
        }

        await addPacketToQueue(toSend);

        packetsToSend -= 1;
        packetIndex += 8;
        toSend.clear();
      }
    } catch (error) {
      print(error);
    }
  }

  List<Uint8List> packetQueue = [];
  bool sending = false;

  Future<void> addPacketToQueue(List<int> packet) async {
    setState(() => packetQueue.add(Uint8List.fromList(packet)));
  }

  Future<void> sendPacketNow() async {
    if (packetQueue.length == 0) return;

    sending = true;
    Uint8List packet = packetQueue[0];
    setState(() => packetQueue.removeAt(0));

    if (packet.length == 0) return;

    print('sending this');
    print(packet);

    await ChirpSDK.send(packet);
    sending = false;
  }

  void assembleReceivedPackets() {
    List<int> result = [];

    receivingPackets.forEach((packet) => result.addAll(packet));

    // Remove packet count
    result.removeAt(0);
    print(result);

    setState(() => this.result = utf8.decode(result));
  }

  @override
  void initState() {
    super.initState();

    _requestPermissions();
    _initChirp();
    _configureChirp();
    _setChirpCallbacks();
    _startAudioProcessing();
  }

  @override
  void dispose() {
    _stopAudioProcessing();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopAudioProcessing();
    } else if (state == AppLifecycleState.resumed) {
      _startAudioProcessing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Calibre',
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Flutter - ChirpSDK Demo',
              style: TextStyle(fontFamily: 'MarkPro')),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Insert your message here'),
                      ),
                    ),
                    Text('Result'),
                    Text(result),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('SEND',
                          style: TextStyle(
                              fontFamily: 'MarkPro', color: Colors.white)),
                      color: Colors.blue,
                      onPressed: _chirpState != ChirpState.stopped
                          ? _sendRandomChirp
                          : null,
                    ),
                    RaisedButton(
                      child: Text(
                          _chirpState == ChirpState.receiving
                              ? 'RECEIVING'
                              : 'RESET',
                          style: TextStyle(
                              fontFamily: 'MarkPro', color: Colors.white)),
                      color: Colors.blue,
                      onPressed: _chirpState != ChirpState.receiving
                          ? () => setState(() => expectingPackets = 0)
                          : null,
                    ),
                    RaisedButton(
                      child: _chirpState == ChirpState.stopped
                          ? const Text('START',
                              style: TextStyle(
                                  fontFamily: 'MarkPro', color: Colors.white))
                          : const Text('STOP',
                              style: TextStyle(
                                  fontFamily: 'MarkPro', color: Colors.white)),
                      color: _chirpState != ChirpState.stopped
                          ? Colors.red
                          : Colors.blue,
                      onPressed: (_chirpState == ChirpState.stopped ||
                              _chirpState == ChirpState.running)
                          ? _toggleChirp
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
