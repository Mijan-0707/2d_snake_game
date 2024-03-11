
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                          for(int i =0;i<20;i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(int i =0;i<20;i++)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: 20,
                              width: 20,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
