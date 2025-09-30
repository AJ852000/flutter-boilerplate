import 'package:flutter/material.dart';

class DeppLinkTest extends StatefulWidget {
  const DeppLinkTest({super.key});

  @override
  State<DeppLinkTest> createState() => _DeppLinkTestState();
}

class _DeppLinkTestState extends State<DeppLinkTest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Deeplink Test"),
      ),
    );
  }
}
