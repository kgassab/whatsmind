import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

void main() => runApp(const WhatsMindApp());

class WhatsMindApp extends StatelessWidget {
  const WhatsMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsMind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _sharedText = 'Share from WhatsApp to see messages here';
  late StreamSubscription _intentSub;

  @override
  void initState() {
    super.initState();
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      setState(() => _sharedText = value.map((v) => v.path).join('\n'));
    });
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() => _sharedText = value.map((v) => v.path).join('\n'));
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsMind'),
        backgroundColor: const Color(0xFF25D366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_sharedText, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
