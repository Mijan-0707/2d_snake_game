import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

    enum Direction{
  up,down,left,right
    }


class _GamePageState extends State<GamePage> {
  int row = 20,column = 20;
  List<int> borderList = [];
  List<int> snakePosition = [];
  var snakeHead = 0;
  var score = 0;
  late Direction direction;
  late int foodPosition;
  @override
  void initState() {
    startGame();
  }
  void startGame(){
    markedBorder();
    generateFoodPosition();
    direction = Direction.right;
    snakePosition = [45,44,43];
    snakeHead = snakePosition.first;
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
      if(checkCollision()){
        timer.cancel();
        showGameOverDialogue();
      }
    });
  }
  void showGameOverDialogue(){
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context) {
      return AlertDialog(
        title: Center(child: const Text('Game Over')),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           const Text('Your Snake Collided'),
            Text('Your Score $score'),
          ],
        ),

        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
            startGame();
          }, child: const Text('Restart')),

        ],
      );
    },);
  }

  bool checkCollision(){
    // if snake collid with border
    if(borderList.contains(snakeHead)) return true;
    // if snake collid with itself
    if(snakePosition.sublist(1).contains(snakeHead)) return true;
    return false;
  }

  void generateFoodPosition(){
    foodPosition = Random().nextInt(row*column);
    if(borderList.contains(foodPosition)){
      generateFoodPosition();
    }
  }

  updateSnake(){
    setState(() {

      switch(direction){

        case Direction.up:
          snakePosition.insert(0, snakeHead-column);
          break;
        case(Direction.down):
          snakePosition.insert(0, snakeHead+column);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHead+1);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHead-1);
          break;
      }
    });
    if(snakeHead == foodPosition){
      score++;
      generateFoodPosition();
    }else{
    snakePosition.removeLast();
    }

    snakeHead= snakePosition.first;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildGameView()),
          _buildGameControllers()
        ],
      ),
    );
  }
  Widget _buildGameView(){
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:column ),
        itemCount: row*column,
        itemBuilder:(context, index) {
         return Container(
           margin:const EdgeInsets.all(1),
           decoration:
           BoxDecoration(
             borderRadius: BorderRadius.circular(8),
             color: fillBoxColor(index)

           ),
         );
        }, );
  }
  Widget _buildGameControllers(){
    return Container(
      padding:const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Score = $score'),
          IconButton(onPressed: (){
            if(direction!=Direction.down) direction = Direction.up;
          }, icon:const Icon(Icons.arrow_circle_up),iconSize: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                if(direction!=Direction.right) direction = Direction.left;
              }, icon:const Icon(Icons.arrow_circle_left_outlined),iconSize: 100,),
              const SizedBox(width: 100,),
              IconButton(onPressed: (){
                if(direction!=Direction.left) direction = Direction.right;
              }, icon:const Icon(Icons.arrow_circle_right_outlined),iconSize: 100,),
            ],
          ),
          IconButton(onPressed: (){
            if(direction!=Direction.up) direction = Direction.down;
          }, icon:const Icon(Icons.arrow_circle_down),iconSize: 100,)
        ],
      ),
    );
  }
  Color fillBoxColor(int index){
    if(borderList.contains(index))
      return Colors.yellow;
    else{
      if(snakePosition.contains(index)){
        if(snakeHead == index)
        {
          return Colors.green;
        }else{
          return Colors.white.withOpacity(0.9);
        }
      }else{
        if(index == foodPosition){
          return Colors.red;
        }
      }

        
    }
    return Colors.grey.withOpacity(0.05);
  }
  markedBorder(){
    for(int i=0;i<column;i++)
      if(!borderList.contains(i)) borderList.add(i);
    for(int i=0;i<row*column;i=i+column)
      if(!borderList.contains(i)) borderList.add(i);
    for(int i=column-1;i<row*column;i=i+column)
      if(!borderList.contains(i)) borderList.add(i);
    for(int i=(row*column)-column;i<row*column;i++)
      if(!borderList.contains(i)) borderList.add(i);
  }

}

