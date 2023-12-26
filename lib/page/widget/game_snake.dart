import 'dart:async';
import 'dart:js';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameSnake  extends StatefulWidget {
  const GameSnake({super.key});

  @override
  State<GameSnake> createState() => _GameSnakeState();
}

enum Direction{up , down, left, right}

class _GameSnakeState extends State<GameSnake> {
  int row = 20, column = 20;
  List<int> borderList = [];
  List<int> snakePosition = [];
  int snakeHead = 0;
  int score = 0;
  late Direction direction;
  late int foodPosition;

  @override
  void initState() {
    startGame();
    super.initState();
  }

  void startGame(){
    makeBoker();
    generateFood();
    direction = Direction.right;
    score = 0;
    snakePosition = [45, 44, 43];
    snakeHead = snakePosition.first;
    Timer.periodic(const Duration(milliseconds: 400), (timer){
      updateSnake();
      if(checkCollision()){
        timer.cancel();
        showGameOverDialog();
      }
    });
  }


  void showGameOverDialog() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("Your Score: $score"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                // Gọi hàm khởi động trò chơi mới tại đây nếu bạn muốn
                startGame();
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }




  bool checkCollision(){
    if(borderList.contains(snakeHead)) return true;
    if(snakePosition.sublist(1).contains(snakeHead)) return true;
    return false;

  }
  void generateFood(){
    foodPosition = Random().nextInt(row * column);
    if(borderList.contains(foodPosition)){
      generateFood();
    }
  }


  void updateSnake(){
    setState(() {

      switch(direction){
        case Direction.up:
          snakePosition.insert(0, snakeHead - column);
          break;
        case Direction.down:
          snakePosition.insert(0, snakeHead + column);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHead + 1);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHead - 1);
          break;

      }
    });

    if(snakeHead == foodPosition){
      score++;
      generateFood();
    } else{
      snakePosition.removeLast();
    }

    snakeHead = snakePosition.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [Expanded(child: _buildGameView()), _buildGameControls()],
      ),
    );
  }

  Widget _buildGameView(){
    return GridView.builder(gridDelegate:
    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: column),
    itemBuilder: (context, index){
      return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: fillBoxColor(index)),
      );
    },
    itemCount: row * column);

  }

  Widget _buildGameControls(){
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Score : $score",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          IconButton(onPressed: (){
            if(direction !=Direction.down) direction = Direction.up;
          },
            icon: const Icon(Icons.arrow_circle_up),
            color: Colors.white,
          iconSize: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                if(direction !=Direction.right) direction = Direction.left;
              },
                icon: const Icon(Icons.arrow_circle_left_outlined),
                color: Colors.white,
                iconSize: 80,
              ),
              const SizedBox(width: 100),
              IconButton(onPressed: (){
                if(direction !=Direction.left) direction = Direction.right;
              },
                icon: const Icon(Icons.arrow_circle_right_outlined),
                color: Colors.white,
                iconSize: 80,
              ),
            ],
          ),
          IconButton(onPressed: (){
            if(direction !=Direction.up) direction = Direction.down;
          },
            icon: const Icon(Icons.arrow_circle_down_outlined),
            color: Colors.white,
            iconSize: 80,
          ),
        ],
      ),

    );

  }

  Color fillBoxColor(int index){
    if(borderList.contains(index))
      return Colors.yellow;
    else{
      if(snakePosition.contains(index)){
        if(snakeHead == index){
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

  makeBoker() {
    // Lặp qua từng dòng
    for (int i = 0; i < row; i++) {
      // Lặp qua từng cột
      for (int j = 0; j < column; j++) {
        // Kiểm tra xem ô hiện tại có ở mép của lưới không. Nếu nằm ở dòng đầu tiên (i == 0), dòng cuối cùng (i == row - 1),
        // cột đầu tiên (j == 0), hoặc cột cuối cùng (j == column - 1), thì đó là một ô nằm ở biên.
        if (i == 0 || i == row - 1 || j == 0 || j == column - 1) {
          int index = i * column + j;
          if (!borderList.contains(index)) borderList.add(index);
        }
      }
    }
  }

}
