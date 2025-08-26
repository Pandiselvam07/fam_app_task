import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'contextual_cards_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: SvgPicture.asset('assets/svg/fampaylogo.svg', height: 45),
      ),
      body: const ContextualCardsContainer(),
    );
  }
}
