import 'package:flutter/material.dart';
import 'dart:math';

String judgement = "assets/images/judgement.jpg";
String justice = "assets/images/justice.jpg";
String strenght = "assets/images/strenght.jpg";
String temperance = "assets/images/temperance.jpg";
String the_chariot = "assets/images/the_chariot.jpg";
String the_fool = "assets/images/the_fool.jpg";
String the_moon = "assets/images/the_moon.jpg";
String the_star = "assets/images/the_star.jpg";
String the_sun = "assets/images/the_sun.jpg";
String the_tower = "assets/images/the_tower.jpg";
String the_magician = "assets/images/the_magician.jpeg";
String the_devil = "assets/images/the_devil.jpeg";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true, //aqui retira a faixa de debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<String>> matriz = [
    [judgement, judgement, justice, justice, strenght, strenght],
    [temperance, temperance, the_chariot, the_chariot, the_fool, the_fool],
    [the_moon, the_moon, the_star, the_star, the_sun, the_sun],
    [the_tower, the_tower, the_magician, the_magician, the_devil, the_devil],
  ];
  

  void shuffleMatrix(List<List<String>> matrix) {
    final random = Random();

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        final randomRow = random.nextInt(matrix.length);
        final randomCol = random.nextInt(matrix[i].length);

        // Troca os elementos
        final temp = matrix[i][j];
        matrix[i][j] = matrix[randomRow][randomCol];
        matrix[randomRow][randomCol] = temp;
      }
    }
  }


  void _incrementCounter() {
    setState(() {
      shuffleMatrix(matriz);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 900,
                height: 600,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: matriz[0].length,
                  ),
                  itemCount: matriz.length * matriz[0].length,
                  itemBuilder: (context, index) {
                    final row = index ~/ matriz[0].length;
                    final col = index % matriz[0].length;
                    return GestureDetector(
                      onTap: () => {
                        print("o usuário digitou na linha: $row"),
                        print("o usuário digitou na coluna: $col"),
                        print("a imagem sendo exibida é a ${matriz[row][col].split("/")[2]}")
                      },
                      child: Container(                        
                        margin: const EdgeInsets.all(8.0),
                        child: Image.asset(matriz[row][col]),                      
                      ) ,
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
